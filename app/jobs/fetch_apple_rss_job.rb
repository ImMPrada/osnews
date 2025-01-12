class FetchAppleRssJob < ApplicationJob
  queue_as :default

  def perform
    Rss::Apple.new.call(pull_news: true)

    self.class.set(wait: 24.hours).perform_later
  end
end
