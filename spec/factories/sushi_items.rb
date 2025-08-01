FactoryBot.define do
  factory :sushi_item do
    sequence(:name) { |n| "寿司#{n}" }
    category
    created_by_user_id { nil }
  end
end
