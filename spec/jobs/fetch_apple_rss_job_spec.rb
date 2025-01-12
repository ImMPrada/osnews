require 'rails_helper'

RSpec.describe FetchAppleRssJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    subject(:perform_job) { described_class.perform_now }

    let(:rss_service) { instance_spy(Rss::Apple) }

    before do
      allow(Rss::Apple).to receive(:new).and_return(rss_service)
    end

    it 'calls the RSS service with pull_news enabled' do
      perform_job
      expect(rss_service).to have_received(:call).with(pull_news: true)
    end

    it 'reschedules itself to run in 24 hours' do
      Timecop.freeze do
        expect { perform_job }.to have_enqueued_job(described_class)
          .at(24.hours.from_now)
          .on_queue('default')
      end
    end
  end
end
