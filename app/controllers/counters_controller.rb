class CountersController < ApplicationController
  def reset_items
    counter = current_user.counters.find(params[:id])
    counter.sushi_item_counters.destroy_all

    redirect_back fallback_location: sushi_items_path, notice: "カウントをリセットしました"
  end
end
