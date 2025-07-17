FactoryBot.define do
  factory :counter do
    eaten_at { Date.today }
    store_name { "スシロー" }
    user
  end
end