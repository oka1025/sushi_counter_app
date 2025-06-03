class SushiItemCounter < ApplicationRecord
  validates :count, presence: true
  belongs_to :sushi_item
  belongs_to :counter
end
