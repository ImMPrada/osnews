module Rss
  class Apple
    URL = 'https://developer.apple.com/news/releases/rss/releases.rss'.freeze
    TITLE_REGEX = /^(iOS|iPadOS|macOS|tvOS|visionOS|watchOS)/

    attr_accessor :title, :items, :updated_items_list

    def call(pull_news: false)
      @items = build_items
      @title = feed.channel.title
      @updated_items_list = []

      save_items_to_db if pull_news
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
      date1 = item1.respond_to?(:pubDate) ? item1.pubDate : item1.publication_date
      date2 = item2.respond_to?(:pubDate) ? item2.pubDate : item2.publication_date

      date1.to_s > date2.to_s
    end

    def save_items_to_db
      items.each do |name, data|
        existing_item = FeedItem.find_by(name:)
        create_new_record(name, data) and next if existing_item.blank?

        update_if_newer(existing_item, data)
      end

      ReportNewVersionsJob.perform_later(updated_items_list)
    end

    def create_new_record(name, data)
      FeedItem.create(name:, description: data.title, publication_date: data.pubDate)
    end

    def update_if_newer(existing_item, data)
      return unless newer_version?(data, existing_item)

      existing_item.update(description: data.title, publication_date: data.pubDate)
      updated_items_list << existing_item.name
    end
  end
end
