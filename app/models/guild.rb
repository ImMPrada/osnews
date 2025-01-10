class Guild < ApplicationRecord
  validates :external_id, presence: true
  validates :channel_id, presence: true
  validates :external_id, uniqueness: { scope: :channel_id }
end
