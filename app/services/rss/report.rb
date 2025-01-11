module Rss
  class Report
    attr_accessor :companies, :content

    def initialize(companies)
      @companies = companies
      @content = ''
    end

    def call
      companies.each do |company|
        @content += "\n\n**#{company.name}**\n"

        add_feed_items_to_response(company)
      end
    end

    private

    def add_feed_items_to_response(company)
      update_company_feed_items(company) if company.feed_items.empty?

      company.feed_items.each do |feed_item|
        @content += "\n#{feed_item.description}"
      end
    end

    def update_company_feed_items(company)
      rss = rss_class(company).new
      rss.call

      rss.items.each do |key, value|
        company.feed_items.create!(
          name: key,
          description: value.title,
          publication_date: value.pubDate
        )
      end

      company.reload
    end

    def rss_class(company)
      services = {
        'Apple' => Rss::Apple
      }

      services[company.name]
    end
  end
end
