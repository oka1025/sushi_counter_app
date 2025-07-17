FactoryBot.define do
  factory :gacha_list do
    name { "まぐろガチャ" }
    rarity { "rare" }

    after(:build) do |gacha|
      gacha.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/sample.png")),
        filename: "sample.png",
        content_type: "image/png"
      )
    end
  end
end
