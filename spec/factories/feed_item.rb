FactoryBot.define do
  factory :feed_item do
    name { Faker::App.name }
    description { Faker::Lorem.paragraph }
    publication_date { Faker::Time.between(from: 2.days.ago, to: Time.current) }
    association :company
  end
end
