class UserSushiItemImage < ApplicationRecord
  belongs_to :user
  belongs_to :sushi_item
  has_one_attached :image

  validates :user_id, uniqueness: { scope: :sushi_item_id }
end
