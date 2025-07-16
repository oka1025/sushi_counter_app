class Category < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50}
  has_many :sushi_items, dependent: :destroy
end
