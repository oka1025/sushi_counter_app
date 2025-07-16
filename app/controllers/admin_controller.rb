class AdminController < ApplicationController
  before_action :require_admin_user!

  def normalize_kana
    updated_count = 0

    Counter.find_each do |counter|
      next if counter.store_name.blank?
      kana = counter.store_name.tr("ぁ-ん", "ァ-ン")
      counter.update(store_name_kana: kana)
      updated_count += 1
    end

    SushiItem.find_each do |item|
      next if item.name.blank?
      kana = item.name.tr("ぁ-ん", "ァ-ン")
      item.update(name_kana: kana)
      updated_count += 1
    end

    render plain: "✅ kana 正規化完了（#{updated_count} 件更新）"
  end

  private

  def require_admin_user!
    # 管理者のみに制限（たとえばユーザーID = 1）
    unless current_user&.id == 1
      render plain: "403 Forbidden", status: :forbidden
    end
  end
end
