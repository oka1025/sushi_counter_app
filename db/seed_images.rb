# db/seed_images.rb
puts "=== 画像登録開始 ==="

def attach_image(name:, filename:)
  sushi = SushiItem.find_by(name: name, created_by_user_id: nil)
  return puts "見つかりません: #{name}" unless sushi

  if sushi.image.attached?
    puts "スキップ（既に画像あり）: #{name}"
    return
  end

  image_path = Rails.root.join("app/assets/images/seeds/#{filename}")
  unless File.exist?(image_path)
    puts "画像ファイルが存在しません: #{filename}"
    return
  end

  sushi.image.attach(
    io: File.open(image_path),
    filename: filename,
    content_type: "image/png"
  )

  if sushi.image.attached?
    puts "画像登録成功: #{name}"
  else
    puts "画像登録失敗: #{name}"
  end
end

# 必要な寿司を順に登録
attach_image(name: "まぐろ", filename: "maguro.png")
attach_image(name: "とろびんちょう", filename: "bincho.png")
attach_image(name: "サーモン", filename: "salmon.png")
# 他の寿司も必要に応じて追加
