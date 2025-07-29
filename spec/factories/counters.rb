FactoryBot.define do
  factory :counter do
    eaten_at { Time.zone.today }
    store_name { "スシロー" }
    user
  end
end
