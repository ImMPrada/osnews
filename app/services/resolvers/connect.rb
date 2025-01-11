module Resolvers
  class Connect < DiscordEngine::Resolvers::Resolver
    attr_accessor :callback, :content

    def execute_action
      guild_already_exists_response and return if guild.present?

      create_guild
      new_guild_response
    end

    private

    def create_guild
      external_id = context.guild.id
      channel_id = context.channel_id

      @guild = Guild.create!(external_id:, channel_id:)
    end

    def guild
      @guild ||= Guild.find_by(external_id: context.guild.id, channel_id: context.channel_id)
    end

    def guild_already_exists_response
      @callback = DiscordEngine::InteractionCallback.channel_message_with_source
      @content = 'This guild is already connected to osnews through this channel'
    end

    def new_guild_response
      @callback = DiscordEngine::InteractionCallback.channel_message_with_source
      @content = 'Hello this guild is now connected to osnews through this channel'
    end
  end
end
