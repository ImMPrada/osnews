namespace :jobs do
  desc 'Enqueue the Apple RSS feed fetcher job'
  task enqueue_apple_rss: :environment do
    FetchAppleRssJob.perform_now
    puts 'Apple RSS feed fetcher job has been enqueued'
  end
end
