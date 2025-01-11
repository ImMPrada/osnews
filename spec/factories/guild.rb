FactoryBot.define do
  factory :guild do
    external_id { Faker::Number.unique.number(digits: 18).to_s }
    channel_id { Faker::Number.unique.number(digits: 18).to_s }
  end
end
