module Rss
  class Apple
    URL = 'https://developer.apple.com/news/releases/rss/releases.rss'.freeze
    TITLE_REGEX = /^(iOS|iPadOS|macOS|tvOS|visionOS|watchOS)/

    attr_accessor :title, :items

    def call
      @items = build_items
      @title = feed.channel.title
    end

    private

    def feed
      @feed ||= build_feed
    end

    def build_feed
      uri = URI(URL)
      response = Net::HTTP.get(uri)
      feed_response = RSS::Parser.parse(response)
      feed_response.items.each { |item| item.pubDate = Time.zone.parse(item.pubDate.to_s) }

      feed_response
    end

    def build_items
      feed_items = feed.items
      items_by_os = {}

      feed_items.each do |item|
        title = item.title
        next unless title =~ TITLE_REGEX

        os_name = title.split.first
        next unless !items_by_os[os_name] || newer_version?(item, items_by_os[os_name])

        items_by_os[os_name] = item
      end

      items_by_os
    end

    def newer_version?(item1, item2)
      item1.pubDate.to_s > item2.pubDate.to_s
    end
  end
end
