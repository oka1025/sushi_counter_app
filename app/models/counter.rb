class Counter < ApplicationRecord
  validates :eaten_at, presence: true
  belongs_to :user
  has_many :sushi_item_counters, dependent: :destroy
  has_many :sushi_items, through: :sushi_item_counters

  def total_count
    sushi_item_counters.sum{|sic| sic.count }
  end
end
