class Company < ApplicationRecord
  has_many :feed_items, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
