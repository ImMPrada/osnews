class ReportNewVersionsJob < ApplicationJob
  queue_as :default

  def perform(feed_items)
    return if feed_items.empty?

    content = "**we have some news!!**\n\n"
    feed_items.each do |feed_item|
      content += "**#{feed_item.description}** -- #{feed_item.publication_date.to_date}\n"
    end

    message = DiscordEngine::Message.new(content:)
    Guild.all.find_each { |guild| message.create(channel_id: guild.channel_id) }
  end
end
