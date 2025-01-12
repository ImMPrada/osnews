require 'rails_helper'

RSpec.describe Rss::Report do
  let(:company) { create(:company, name: 'Apple') }
  let(:companies) { [company] }
  let(:report) { described_class.new(companies) }

  describe '#call' do
    context 'when company has feed items' do
      let(:feed_item) { create(:feed_item, company: company) }
      let(:expected_content) { "\n\n**Apple**\n\n#{feed_item.description}" }

      before do
        feed_item
        report.call
      end

      it 'adds company name and feed items to content' do
        expect(report.content).to eq(expected_content)
      end
    end

    context 'when company has no feed items' do
      let(:rss_service) { instance_double(Rss::Apple) }
      let(:rss_item) do
        instance_double(
          RSS::Rss::Channel::Item,
          title: 'News Title',
          pubDate: Time.current
        )
      end
      let(:expected_content) { "\n\n**Apple**\n\nNews Title" }

      before do
        allow(Rss::Apple).to receive(:new).and_return(rss_service)
        allow(rss_service).to receive(:call)
        allow(rss_service).to receive(:items).and_return({ 'News 1' => rss_item })

        report.call
      end

      it 'fetches new feed items' do
        expect(rss_service).to have_received(:call)
      end

      it 'creates feed items from RSS' do
        expect(company.feed_items.count).to eq(1)
      end

      it 'adds company name and feed items to content' do
        expect(report.content).to eq(expected_content)
      end
    end
  end
end
