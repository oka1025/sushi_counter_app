class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :sushi_item
end
