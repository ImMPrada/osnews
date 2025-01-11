module Resolvers
  class Connect < DiscordEngine::Resolvers::Resolver
    attr_accessor :callback, :content

    def execute_action
      create_guild

      @callback = DiscordEngine::InteractionCallback.channel_message_with_source
      @content = 'Hello this guild is now connected to osnews through this channel'
    end

    private

    attr_accessor :guild

    def create_guild
      external_id = context.guild.id
      channel_id = context.channel_id

      @guild = Guild.create!(external_id: external_id, channel_id: channel_id)
    end
  end
end
