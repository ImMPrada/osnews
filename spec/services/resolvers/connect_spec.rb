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
        expect(resolver.content).to eq('This guild is already connected to osnews through this channel')
      end
    end

    context 'when guild does not exist' do
      let(:guild) { Guild.last }

      before do
        resolver.execute_action
      end

      it 'creates a new guild' do
        expect(Guild.count).to eq(1)
      end

      it 'sets the correct external_id' do
        expect(guild.external_id).to eq(guild_id)
      end

      it 'sets the correct channel_id' do
        expect(guild.channel_id).to eq(channel_id)
      end

      it 'sets the callback type' do
        expect(resolver.callback.type).to eq(channel_message_callback.type)
      end

      it 'returns new guild message' do
        expect(resolver.content).to eq('Hello this guild is now connected to osnews through this channel')
      end
    end
  end
end
