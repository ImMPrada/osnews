class NewVersionsNoticeReport
  attr_reader :feed_items

  def initialize(feed_items)
    @feed_items = feed_items
  end

  def call
    return if feed_items.empty?

    content = "🤖 **we have some news!!**\n\n"
    feed_items.each do |feed_item|
      content += "**#{feed_item.description}** 🗓️ #{feed_item.publication_date.to_date}\n"
    end

    message = DiscordEngine::Message.new(content:)
    Guild.find_each { |guild| message.create(channel_id: guild.channel_id) }
  end
end
