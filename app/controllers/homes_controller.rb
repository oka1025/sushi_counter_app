class HomesController < ApplicationController
  def index
    counters = current_user.counters
      .where(saved: true)

    sushi_counts_3 = counters
      .joins(sushi_item_counters: :sushi_item)
      .where.not(sushi_item_counters: { count: [nil, "0"] })
      .group("sushi_items.name")
      .sum("sushi_item_counters.count")

    sorted_sushi_counts = sushi_counts_3.sort_by { |_, count| -count }

    ranked_sushis = []
    rank = 0
    position = 0
    last_count = nil

    sorted_sushi_counts.each do |sushi, count|
      position += 1
      rank = position if count != last_count
      last_count = count
      break if rank > 3
      ranked_sushis << [sushi, count, rank]
    end
    @popular_sushis = ranked_sushis

    
  end
end
