FactoryBot.define do
  factory :user do
    name { "testname"}
    email { Faker::Internet.unique.email }
    password { "password123" }
  end
end
