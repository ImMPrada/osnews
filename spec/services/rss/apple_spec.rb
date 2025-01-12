require 'rails_helper'

RSpec.describe Rss::Apple, :vcr do
  describe '#call' do
    let(:feed_double) { instance_double(RSS::Rss, channel: channel_double) }
    let(:channel_double) { instance_double(RSS::Rss::Channel, title: 'Apple Releases') }
    let(:service) { described_class.new }

    context 'when fetching RSS feed' do
      before do
        VCR.use_cassette('apple_rss') do
          service.call
        end
      end

      it 'sets the feed title' do
        expect(service.title).to be_present
      end

      it 'returns items as a hash' do
        expect(service.items).to be_a(Hash)
      end

      it 'returns only the expected OS types' do
        expect(service.items.keys).to match_array(%w[iOS iPadOS macOS tvOS visionOS watchOS])
      end

      it 'parses dates correctly' do
        service.items.each_value do |item|
          expect(item.pubDate).to be_a(ActiveSupport::TimeWithZone)
        end
      end
    end

    context 'when saving items to database' do
      let(:mock_item) do
        instance_double(RSS::Rss::Channel::Item,
                        title: 'iOS 17.3',
                        description: 'New features and improvements',
                        pubDate: Time.current)
      end

      context 'with pull_news disabled' do
        let(:service) do
          instance = described_class.new
          allow(instance).to receive_messages(feed: feed_double, build_items: { 'iOS' => mock_item })
          instance
        end

        it 'does not create new records' do
          expect { service.call }.not_to change(FeedItem, :count)
        end
      end

      context 'with pull_news enabled' do
        context 'with new items' do
          let(:service) do
            instance = described_class.new
            allow(instance).to receive_messages(feed: feed_double, build_items: { 'iOS' => mock_item })
            instance
          end

          it 'creates new records' do
            expect { service.call(pull_news: true) }.to change(FeedItem, :count).by(1)
          end

          it 'sets the correct name' do
            service.call(pull_news: true)
            expect(FeedItem.last.name).to eq('iOS')
          end

          it 'sets the correct description' do
            service.call(pull_news: true)
            expect(FeedItem.last.description).to eq('iOS 17.3')
          end

          it 'sets the publication date' do
            service.call(pull_news: true)
            expect(FeedItem.last.publication_date).to be_present
          end
        end

        context 'with existing items' do
          let!(:existing_item) do
            create(:feed_item,
                   name: 'iOS',
                   description: 'Old description',
                   publication_date: 1.day.ago)
          end

          context 'when new version is available' do
            let(:service) do
              instance = described_class.new
              allow(instance).to receive_messages(feed: feed_double, build_items: { 'iOS' => mock_item })
              instance
            end

            it 'does not create new records' do
              expect { service.call(pull_news: true) }.not_to change(FeedItem, :count)
            end

            it 'updates the description' do
              service.call(pull_news: true)
              existing_item.reload
              expect(existing_item.description).to eq('iOS 17.3')
            end
          end

          context 'when existing version is newer' do
            let(:old_mock_item) do
              instance_double(RSS::Rss::Channel::Item,
                              title: 'iOS 17.3',
                              description: 'Old description',
                              pubDate: 2.days.ago)
            end

            let(:service) do
              instance = described_class.new
              allow(instance).to receive_messages(feed: feed_double, build_items: { 'iOS' => old_mock_item })
              instance
            end

            it 'does not update the record' do
              service.call(pull_news: true)
              existing_item.reload
              expect(existing_item.description).to eq('Old description')
            end
          end
        end
      end
    end

    context 'with invalid RSS items' do
      let(:invalid_item) do
        instance_double(RSS::Rss::Channel::Item,
                        title: 'Random Title',
                        description: 'Invalid description',
                        pubDate: Time.current)
      end

      let(:service) do
        instance = described_class.new
        allow(instance).to receive(:build_feed).and_return(
          instance_double(RSS::Rss,
                          channel: instance_double(RSS::Rss::Channel, title: 'Apple Releases'),
                          items: [invalid_item])
        )
        instance
      end

      it 'filters out items with invalid titles' do
        service.call
        expect(service.items).to be_empty
      end
    end
  end
end
