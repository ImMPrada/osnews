require 'rails_helper'

RSpec.describe Resolvers::Report do
  let(:guild_id) { '123456789' }
  let(:channel_id) { '987654321' }
  let(:context) do
    instance_double(
      DiscordEngine::Resolvers::Context,
      guild: instance_double(DiscordEngine::Guild, id: guild_id),
      channel_id: channel_id
    )
  end
  let(:resolver) { described_class.new(context: context) }
  let(:channel_message_callback) { DiscordEngine::InteractionCallback.channel_message_with_source }

  describe '#execute_action' do
    context 'when guild is not connected' do
      before { resolver.execute_action }

      it 'sets the callback type' do
        expect(resolver.callback.type).to eq(channel_message_callback.type)
      end

      it 'returns not connected message' do
        expect(resolver.content).to eq(
          '❌ This Discord server is not connected to OSNews yet! Use /connect to get started ✨'
        )
      end
    end

    context 'when guild is connected' do
      let(:company) { create(:company, name: 'Apple') }
      let(:feed_item) { create(:feed_item, company: company) }
      let(:report_content) { "\n\n**Apple**\n\n#{feed_item.description}" }

      before do
        create(:guild, external_id: guild_id, channel_id: channel_id)
        feed_item
        resolver.execute_action
      end

      it 'sets the callback type' do
        expect(resolver.callback.type).to eq(channel_message_callback.type)
      end

      it 'returns the report content' do
        expect(resolver.content).to eq(report_content)
      end
    end
  end
end
