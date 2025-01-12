class FetchAppleRssJob < ApplicationJob
  queue_as :default

  TIME_TO_WAIT = 24.hours

  def perform
    Rss::Apple.new.call(pull_news: true)

    self.class.set(wait: TIME_TO_WAIT).perform_later
  end
end
