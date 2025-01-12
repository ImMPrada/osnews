class FeedItem < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :publication_date, presence: true
end
