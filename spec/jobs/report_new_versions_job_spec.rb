require 'rails_helper'

RSpec.describe ReportNewVersionsJob, type: :job do
  describe '#perform' do
    let!(:guild) { create(:guild, channel_id: '123456789') }
    let(:feed_item) do
      create(:feed_item,
             description: 'New iOS version',
             publication_date: Time.zone.parse('2024-01-15'))
    end
    let(:message_double) { instance_double(DiscordEngine::Message, create: true) }

    context 'when feed items are empty' do
      it 'does not send any message' do
        allow(DiscordEngine::Message).to receive(:new)

        described_class.perform_now([])

        expect(DiscordEngine::Message).not_to have_received(:new)
      end
    end

    context 'when feed items exist' do
      it 'sends a formatted message to all guilds' do
        expected_content = "**we have some news!!**\n\n**New iOS version** -- 2024-01-15\n"
        allow(DiscordEngine::Message).to receive(:new).and_return(message_double)

        described_class.perform_now([feed_item])

        expect(DiscordEngine::Message).to have_received(:new).with(content: expected_content)
      end

      it "sends the message to each guild's channel" do
        allow(DiscordEngine::Message).to receive(:new).and_return(message_double)

        described_class.perform_now([feed_item])

        expect(message_double).to have_received(:create).with(channel_id: guild.channel_id)
      end
    end
  end
end
