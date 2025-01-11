require 'rails_helper'

RSpec.describe Resolvers::Connect do
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
    context 'when guild already exists' do
      before do
        create(:guild, external_id: guild_id, channel_id: channel_id)
        resolver.execute_action
      end

      it 'sets the callback type' do
        expect(resolver.callback.type).to eq(channel_message_callback.type)
      end

      it 'returns existing guild message' do
        expect(resolver.content).to eq('✨ This Discord server is already connected to OSNews in this channel! ✨')
      end
    end

    context 'when guild does not exist' do
      before { resolver.execute_action }

      it 'creates a new guild' do
        expect(Guild.count).to eq(1)
      end

      it 'sets the correct external_id for the guild' do
        expect(Guild.last.external_id).to eq(guild_id)
      end

      it 'sets the correct channel_id for the guild' do
        expect(Guild.last.channel_id).to eq(channel_id)
      end

      it 'sets the callback type' do
        expect(resolver.callback.type).to eq(channel_message_callback.type)
      end

      it 'returns new guild message' do
        expect(resolver.content).to eq('✨ This guild is now connected to OSNews through this channel! ✨')
      end
    end
  end
end
