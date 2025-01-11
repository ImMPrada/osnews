require 'rails_helper'

RSpec.describe RSS::Apple, :vcr do
  describe '#call' do
    subject(:service) { described_class.new }

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
end
