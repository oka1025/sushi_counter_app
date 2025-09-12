class SushiItemCounter < ApplicationRecord
  validates :count, presence: true
  belongs_to :sushi_item
  belongs_to :counter

  def update_count!(direction)
    self.count ||= 0

    case direction
    when "increment"
      self.count += 1
    when "decrement"
      self.count = [self.count - 1, 0].max
    end

    save!
  end
end
