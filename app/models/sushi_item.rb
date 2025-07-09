class SushiItem < ApplicationRecord
  validates :name, presence: true
  belongs_to :category
  belongs_to :created_by_user, class_name: "User", optional: true
  has_many :sushi_item_counters, dependent: :destroy
  has_one_attached :image
  has_many :user_sushi_item_images, dependent: :destroy
  attr_accessor :reset_to_default_image
  attr_accessor :remove_image

  before_destroy :prevent_system_item_deletion
  before_update :prevent_system_item_editing
  before_save :purge_image_if_requested
  before_validation :set_name_kana

  private

  def prevent_system_item_deletion
    if created_by_user_id.nil?
      errors.add(:base, "初期データの寿司は削除できません")
      throw(:abort)
    end
  end

  def prevent_system_item_editing
    return if created_by_user_id.present?

    # nameやcategory_idなどが変更されているか確認
    if saved_change_to_name? || saved_change_to_category_id?
      errors.add(:base, "初期データの寿司は編集できません")
      throw(:abort)
    end
  end

  def purge_image_if_requested
    image.purge if remove_image == "1"
  end

  def set_name_kana
    self.name_kana = name.tr("ぁ-ん", "ァ-ン") if name.present?
  end
end