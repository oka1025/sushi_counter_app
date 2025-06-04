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
  { name: "まぐろ", category: nigiri, image_file: "maguro.png" },
].each do |data|
  existing = SushiItem.find_by(name: data[:name], created_by_user_id: nil)
  if existing
    puts "スキップ: #{existing.name}（すでに初期データあり）"
    next
  end

  sushi = SushiItem.find_or_initialize_by(name: data[:name])
  sushi.created_by_user_id = nil
  sushi.category = data[:category]

  image_path = Rails.root.join("app/assets/images/seeds/#{data[:image_file]}")
  unless File.exist?(image_path)
    puts "画像ファイルが存在しません: #{image_path}"
  else
    sushi.image.attach(
      io: File.open(image_path),
      filename: data[:image_file],
      content_type: "image/png"
    )
  end
  
  if sushi.save
    puts "保存成功: #{sushi.name}"
  else
    puts "保存失敗: #{sushi.name}"
    puts sushi.errors.full_messages
  end
end