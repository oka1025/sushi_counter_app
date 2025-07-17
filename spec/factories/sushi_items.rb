FactoryBot.define do
  factory :sushi_item do
    name { "のどぐろ" }
    category
    created_by_user_id { nil }
  end
end
