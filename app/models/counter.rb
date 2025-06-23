class Counter < ApplicationRecord
  validates :eaten_at, presence: true
  belongs_to :user
  has_many :sushi_item_counters, dependent: :destroy
  has_many :sushi_items, through: :sushi_item_counters

  attribute :saved, :boolean, default: false

  def total_sushi_count
    sushi_item_counters.sum{|sic| sic.count }
  end

  ransacker :counter_total_count do
    Arel.sql("COALESCE((SELECT SUM(sushi_item_counters.count)
                        FROM sushi_item_counters
                        WHERE sushi_item_counters.counter_id = counters.id), 0)")
  end
end
