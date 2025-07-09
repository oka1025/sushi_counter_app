# scripts/normalize_kana.rb
Rails.application.executor.wrap do
  Counter.find_each do |c|
    next unless c.store_name.present?
    c.update_column(:store_name_kana, c.store_name.tr("ぁ-ん", "ァ-ン"))
  end

  SushiItem.find_each do |s|
    next unless s.name.present?
    s.update_column(:name_kana, s.name.tr("ぁ-ん", "ァ-ン"))
  end
end
