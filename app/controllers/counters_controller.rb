class CountersController < ApplicationController
  def reset_items
    counter = current_user.counters.find(params[:id])
    counter.sushi_item_counters.destroy_all

    redirect_back fallback_location: sushi_items_path, notice: "カウントをリセットしました"
  end

  def new 
    if current_counter
      @counter = current_counter
      @counter.update!(eaten_at: Time.current)
    else
      current_user.counters.create!(eaten_at: Time.current)
    end
    session[:counter_update_source] = "new"
  end

  def update
    @counter = current_user.counters.find(params[:id])
    @new_counter = current_user.counters.order(created_at: :desc).first
    @counter.update(saved: true)

    if @counter.update(counter_params.except(:update_source))
      if params[:counter][:update_source] == "new"
        clear_current_counter
        current_user.increment!(:coin, @counter.total_sushi_count)
        redirect_to counters_path, notice: "#{@counter.total_sushi_count}コイン獲得しました"
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
    base_scope = current_user.counters
                      .includes(:sushi_item_counters)
                      .left_joins(:sushi_item_counters)
                      .where(saved: true)
                      .select("counters.*, COALESCE(SUM(sushi_item_counters.count), 0) as counter_total_count")
                      .group("counters.id")

    @q = base_scope.ransack(params[:q])
    @counters = @q.result.order(sort_order(params[:sort])).page(params[:page]).per(20)
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

  def summary
    counters = current_user.counters
      .where(saved: true)

    base_scope = counters
      .joins(sushi_item_counters: :sushi_item)

    sushi_grouped = base_scope
      .group("sushi_items.name")

    @q = base_scope.ransack(params[:q])
    filtered_scope = @q.result

    @total_sushi = counters.joins(:sushi_item_counters).sum("sushi_item_counters.count")

    store_counts = counters
      .where.not(store_name: [nil, ""])
      .group(:store_name)
      .count

    sorted_counts = store_counts.sort_by { |_, count| -count }

    ranked_stores = []
    rank = 0
    position = 0
    last_count = nil

    sorted_counts.each do |store, count|
      position += 1
      rank = position if count != last_count
      last_count = count

      break if rank > 3
      ranked_stores << [store, count, rank]
    end

    @popular_stores = ranked_stores

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

    sushi_counts = filtered_scope
      .joins(sushi_item_counters: :sushi_item)
      .where.not(sushi_item_counters: { count: [nil, "0"] })
      .group("sushi_items.name")
      .select("sushi_items.name, SUM(sushi_item_counters.count) AS total_count")

    if params.dig(:q, :total_count_gteq).present?
      sushi_counts = sushi_counts.having("SUM(sushi_item_counters.count) >= ?", params[:q][:total_count_gteq])
    end
    if params.dig(:q, :total_count_lteq).present?
      sushi_counts = sushi_counts.having("SUM(sushi_item_counters.count) <= ?", params[:q][:total_count_lteq])
    end

    order_sql = case sushi_sort_order(params[:sort])
              when /total_count ASC/ then "total_count ASC"
              when /total_count DESC/ then "total_count DESC"
              when /name ASC/ then "sushi_items.name ASC"
              when /name DESC/ then "sushi_items.name DESC"
              else "total_count DESC"
              end

    sushi_counts = sushi_counts.order(order_sql)

    @sushi_ranks = []
    rank = 0
    position = 0
    last_count = nil

    sushi_counts.each do |record|
      position += 1
      count = record.total_count.to_i
      rank = position if count != last_count
      last_count = count
      @sushi_ranks << { rank: rank, name: record.name, count: count }
    end
    @total_sushi_count = sushi_counts.sum { |r| r.total_count.to_i }
    @paginated_sushi_counts = Kaminari.paginate_array(@sushi_ranks).page(params[:page]).per(50)
  end

  private

  def action_from_source(source)
    source == "edit" ? :edit : :new
  end

  def counter_params
    params.require(:counter).permit( :eaten_at, :store_name, :user_id, :update_source )
  end

  def search_params
    params.fetch(:q, {}).permit(:eaten_at_gteq, :eaten_at_lteq, :store_name_cont, :counter_total_count_gteq, :counter_total_count_lteq, :name_cont)
  end

  def sort_order(param)
    case param
    when "date_asc"
      "eaten_at ASC, created_at ASC"
    when "date_desc"
      "eaten_at DESC, created_at DESC"
    when "count_asc"
      "counter_total_count ASC, created_at ASC"
    when "count_desc"
      "counter_total_count DESC, created_at DESC"
    else
      "eaten_at DESC, created_at DESC"
    end
  end

  def sushi_sort_order(param)
    case param
    when "count_asc"
      "total_count ASC, name ASC"
    when "count_desc"
      "total_count DESC, name DESC"
    when "name_asc"
      "name ASC"
    when "name_desc"
      "name DESC"
    else
      "total_count DESC"
    end
  end
end
