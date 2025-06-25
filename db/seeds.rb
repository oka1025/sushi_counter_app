# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
nigiri = Category.find_or_create_by!(name: "にぎり")
gunkan = Category.find_or_create_by!(name: "軍艦・巻物")
side = Category.find_or_create_by!(name: "サイドメニュー")
dessert = Category.find_or_create_by!(name: "デザート")
others = Category.find_or_create_by!(name: "その他")

[
  { name: "まぐろ", category: nigiri },
  { name: "とろびんちょう", category: nigiri },
  { name: "サーモン", category: nigiri },
  { name: "オニオンサーモン", category: nigiri },
  { name: "焼とろサーモン", category: nigiri },
  { name: "炙りサーモン", category: nigiri },
  { name: "えび", category: nigiri },
  { name: "生えび", category: nigiri },
  { name: "甘えび", category: nigiri },
  { name: "えびアボカド", category: nigiri },
  { name: "炙りえび", category: nigiri },
  { name: "えび天握り", category: nigiri },
  { name: "いか", category: nigiri },
  { name: "いか天握り", category: nigiri },
  { name: "たこ", category: nigiri },
  { name: "しめさば", category: nigiri },
  { name: "えんがわ", category: nigiri },
  { name: "はまち", category: nigiri },
  { name: "たい", category: nigiri },
  { name: "あじ", category: nigiri },
  { name: "いわし", category: nigiri },
  { name: "かつお", category: nigiri },
  { name: "ほたて", category: nigiri },
  { name: "つぶ貝", category: nigiri },
  { name: "赤貝", category: nigiri },
  { name: "たまご", category: nigiri },
  { name: "あなご", category: nigiri },
  { name: "生ハム", category: nigiri },
  { name: "豚塩カルビ", category: nigiri },
  { name: "ハンバーグ", category: nigiri },

  { name: "まぐろたたき", category: gunkan },
  { name: "まぐろユッケ", category: gunkan },
  { name: "まぐたく", category: gunkan },
  { name: "まぐろ山かけ", category: gunkan },
  { name: "かにみそ", category: gunkan },
  { name: "かにマヨ", category: gunkan },
  { name: "たらマヨ", category: gunkan },
  { name: "コーン", category: gunkan },
  { name: "ツナサラダ", category: gunkan },
  { name: "シーフードサラダ", category: gunkan },
  { name: "納豆", category: gunkan },
  { name: "いかおくら", category: gunkan },
  { name: "いくら", category: gunkan },
  { name: "数の子", category: gunkan },
  { name: "うに", category: gunkan },
  { name: "きゅうり巻", category: gunkan },
  { name: "鉄火巻", category: gunkan },
  { name: "納豆巻", category: gunkan },
  { name: "いなり", category: gunkan },

  { name: "茶碗蒸し", category: side },
  { name: "みそ汁", category: side },
  { name: "かけうどん", category: side },
  { name: "きつねうどん", category: side },
  { name: "ラーメン", category: side },
  { name: "そば", category: side },
  { name: "フライドポテト", category: side },
  { name: "鶏のから揚げ", category: side },
  { name: "なんこつのから揚げ", category: side },

  { name: "ミルクレープ", category: dessert },
  { name: "チョコケーキ", category: dessert },
  { name: "チーズケーキ", category: dessert },
  { name: "大学いも", category: dessert },
  { name: "わらびもち", category: dessert },
  { name: "プリン", category: dessert },
  { name: "マンゴー", category: dessert },
  { name: "パイン", category: dessert },
  { name: "バニラアイス", category: dessert },
].each do |data|
  existing = SushiItem.find_by(name: data[:name], created_by_user_id: nil)
  if existing
    puts "スキップ: #{existing.name}（すでに初期データあり）"
    next
  end

  sushi = SushiItem.find_or_initialize_by(name: data[:name])
  sushi.created_by_user_id = nil
  sushi.category = data[:category]

  if sushi.save
    puts "保存成功: #{sushi.name}"
  else
    puts "保存失敗: #{sushi.name}"
    puts sushi.errors.full_messages
  end
end


puts "🌱 Seeding GachaList..."

def attach_image(record, filename)
  filepath = Rails.root.join("db/seeds/images/#{filename}")
  return unless File.exist?(filepath)

  record.image.attach(io: File.open(filepath), filename: filename, content_type: "image/png")
end

gachas = [
  { name: "地球スシ", rarity: :normal, image: "chikyu.PNG", weight: 60 },
  { name: "マグロライダー", rarity: :rare, image: "maguro_biker.PNG", weight: 30 },
  { name: "えび天キッド", rarity: :super_rare, image: "ebiten_kid.PNG", weight: 9 }
]

gachas.each do |attrs|
  existing = GachaList.find_by(name: attrs[:name])
  if existing
    puts "⏩ #{attrs[:name]} は既に存在します。スキップします"
    next
  end

  gacha = GachaList.create!(name: attrs[:name], rarity: attrs[:rarity], weight: attrs[:weight])
  attach_image(gacha, attrs[:image])
  puts "✅ #{gacha.name} を作成しました"
end
