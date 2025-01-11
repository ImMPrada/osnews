module Resolvers
  class Report < DiscordEngine::Resolvers::Resolver
    attr_accessor :callback, :content

    def execute_action
      @callback = DiscordEngine::InteractionCallback.channel_message_with_source
      guild_not_connected_response and return if guild.blank?

      @content = ''
      add_news_to_response
    end

    private

    def guild
      @guild ||= Guild.find_by(external_id: context.guild.id, channel_id: context.channel_id)
    end

    def guild_not_connected_response
      @content = '❌ This Discord server is not connected to OSNews yet! Use /connect to get started ✨'
    end

    def add_news_to_response
      companies = Company.all
      report = Rss::Report.new(companies)
      report.call

      @content += report.content
    end
  end
end