class CountersController < ApplicationController
  def reset_items
    counter = current_user.counters.find(params[:id])
    counter.sushi_item_counters.destroy_all

    redirect_back fallback_location: sushi_items_path, notice: "カウントをリセットしました"
  end

  def new
    @counter = current_user.counters.order(created_at: :desc).first
  end

  def update
    @counter = current_user.counters.find(params[:id])
    if @counter.update(counter_params.except(:update_source))
      if params[:counter][:update_source] == "new"
        clear_current_counter
        current_user.increment!(:coin, @counter.total_count)
        redirect_to counters_path, notice: "カウントを保存しました"
      elsif params[:counter][:update_source] == "edit"
        redirect_to counters_path, notice: "カウントを更新しました"
      end
    else
      render action_from_source(params[:counter][:update_source]), status: :unprocessable_entity
    end
  end

  def index
    @counter = current_user.counters.find_by(params[:id])
  end

  def edit
    @counter = current_user.counters.find(params[:id])
  end

  private

  def action_from_source(source)
    source == "edit" ? :edit : :new
  end

  def counter_params
    params.require(:counter).permit( :eaten_at, :store_name, :user_id, :update_source )
  end
end
