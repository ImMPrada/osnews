require 'rails_helper'

RSpec.describe FeedItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:company) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:publication_date) }
  end
end
