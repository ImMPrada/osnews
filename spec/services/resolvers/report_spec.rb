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
      let(:guild) { create(:guild, external_id: guild_id, channel_id: channel_id) }
      let(:older_feed_item) { create(:feed_item, description: 'News 1', publication_date: '2024-01-01') }
      let(:newer_feed_item) { create(:feed_item, description: 'News 2', publication_date: '2024-01-02') }
      let(:expected_content) { "\n**News 1** -- 2024-01-01\n**News 2** -- 2024-01-02" }

      before do
        guild
        older_feed_item
        newer_feed_item
        resolver.execute_action
      end

      it 'sets the callback type' do
        expect(resolver.callback.type).to eq(channel_message_callback.type)
      end

      it 'has the expected number of feed items' do
        expect(FeedItem.count).to eq(2)
      end

      it 'includes the older feed item' do
        expect(resolver.content).to include(older_feed_item.description)
      end

      it 'includes the newer feed item' do
        expect(resolver.content).to include(newer_feed_item.description)
      end

      it 'formats the content correctly' do
        expect(resolver.content).to eq(expected_content)
      end
    end
  end
end
