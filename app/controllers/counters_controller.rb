class CountersController < ApplicationController
  def reset_items
    counter = current_user.counters.find(params[:id])
    counter.sushi_item_counters.destroy_all

    redirect_back fallback_location: sushi_items_path, notice: "カウントをリセットしました"
  end

  def new
    @counter = current_counter || current_user.counters.create!(eaten_at: Time.current)
    session[:counter_update_source] = "new"
  end

  def update
    @counter = current_user.counters.find(params[:id])
    @new_counter = current_user.counters.order(created_at: :desc).first
    @counter.update(saved: true)

    if @counter.update(counter_params.except(:update_source))
      if params[:counter][:update_source] == "new"
        clear_current_counter
        current_user.increment!(:coin, @counter.total_count)
        redirect_to counters_path, notice: "#{@counter.total_count}コイン獲得しました"
        counter = current_user.counters.create!(eaten_at: Time.current)
        set_current_counter(counter)
      elsif params[:counter][:update_source] == "edit"
        clear_current_counter
        set_current_counter(@new_counter)
        session.delete(:counter_update_source)
        redirect_to counters_path, notice: "カウントを更新しました"
      end
    else
      render action_from_source(params[:counter][:update_source]), status: :unprocessable_entity
    end
  end

  def index
    @counters = current_user.counters
                            .includes(:sushi_item_counters)
                            .where(saved: true)
                            .order(eaten_at: :desc, created_at: :desc)
  end

  def edit
    @counter = current_user.counters.find(params[:id])
  end

  def use
    @counter = current_user.counters.find(params[:id])
    set_current_counter(@counter)
    session[:counter_update_source] = "edit"
    redirect_to sushi_items_path, notice: "カウントを編集します"
  end

  def destroy
    counter = current_user.counters.find(params[:id])
    counter.destroy!
    redirect_to counters_path, notice: "削除しました"
  end

  private

  def action_from_source(source)
    source == "edit" ? :edit : :new
  end

  def counter_params
    params.require(:counter).permit( :eaten_at, :store_name, :user_id, :update_source )
  end
end
