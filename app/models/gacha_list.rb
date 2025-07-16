class GachaList < ApplicationRecord
  has_many :user_gacha_lists, dependent: :destroy
  has_many :users, through: :user_gacha_lists

  has_one_attached :image

  enum :rarity, {
    normal: 0,
    rare: 1,
    super_rare: 2,
    special: 3
  }  
end
