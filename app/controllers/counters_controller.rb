class CountersController < ApplicationController
  def reset_items
    counter = current_user.counters.find(params[:id])
    counter.sushi_item_counters.destroy_all

    redirect_back fallback_location: sushi_items_path, notice: t('counters.reset_notice')
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

  def new 
    if current_counter
      @counter = current_counter
      @counter.update!(eaten_at: Time.current)
    else
      @counter = current_user.counters.create!(eaten_at: Time.current)
    end
    session[:counter_update_source] = "new"
  end

  def edit
    @counter = current_user.counters.find(params[:id])
  end

  def update
    @counter = current_user.counters.find(params[:id])
    @new_counter = current_user.counters.order(created_at: :desc).first
    @counter.update(saved: true)

    if @counter.update(counter_params.except(:update_source))
      if params[:counter][:update_source] == "new"
        clear_current_counter
        current_user.coin += @counter.total_sushi_count
        current_user.save!
        redirect_to counters_path, notice: "#{@counter.total_sushi_count}コイン獲得しました"
        counter = current_user.counters.create!(eaten_at: Time.current)
        set_current_counter(counter)
      elsif params[:counter][:update_source] == "edit"
        clear_current_counter
        set_current_counter(@new_counter)
        session.delete(:counter_update_source)
        redirect_to counters_path, notice: t('counters.update_notice')
      else 
        redirect_to counters_path, notice: "保存しました"
      end
    else
      render action_from_source(params[:counter][:update_source]), status: :unprocessable_entity
    end
  end

  def use
    @counter = current_user.counters.find(params[:id])
    set_current_counter(@counter)
    session[:counter_update_source] = "edit"
    redirect_to sushi_items_path, notice: t('counters.edit_notice')
  end

  def destroy
    counter = current_user.counters.find(params[:id])
    counter.destroy!
    redirect_to counters_path, notice: t('counters.destroy_notice')
  end

  def summary
    @q = filtered_ransack_scope
    @total_sushi = total_sushi_count
    @popular_stores = top_stores(3)
    @popular_sushis = top_sushis(3)
    @sushi_ranks = ranked_sushis
    @total_sushi_count = @sushi_ranks.sum { |r| r[:count] }
    @paginated_sushi_counts = Kaminari.paginate_array(@sushi_ranks).page(params[:page]).per(50)
  end

  def autocomplete_store_name
    term = params[:term].to_s.tr("ぁ-ん", "ァ-ン")
    logger.info "🔍 autocomplete term: #{term}"

    store_names = current_user.counters
      .where("store_name_kana LIKE ?", "%#{term}%")
      .distinct
      .limit(10)
      .pluck(:store_name)

    render json: store_names
  end

  def autocomplete_sushi_name
    term = params[:term].to_s.tr("ぁ-ん", "ァ-ン")
    logger.info "🔍 autocomplete term: #{term}"


    names = current_user.counters
      .joins(sushi_item_counters: :sushi_item)
      .where("sushi_items.name_kana LIKE ?", "%#{term}%")
      .distinct
      .limit(10)
      .pluck("sushi_items.name")

    render json: names
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
    mapping = {
      "date_asc" => "eaten_at ASC, created_at ASC",
      "date_desc" => "eaten_at DESC, created_at DESC",
      "count_asc" => "counter_total_count ASC, created_at ASC",
      "count_desc" => "counter_total_count DESC, created_at DESC"
    }
    mapping[param] || "eaten_at DESC, created_at DESC"
  end

  def sushi_sort_order(param)
    mapping = {
      "count_asc" => "total_count ASC, name ASC",
      "count_desc" => "total_count DESC, name DESC",
      "name_asc" => "name ASC",
      "name_desc" => "name DESC"
    }
    mapping[param] || "total_count DESC"
  end

  def saved_counters
    current_user.counters.where(saved: true)
  end

  def filtered_ransack_scope
    saved_counters.joins(sushi_item_counters: :sushi_item).ransack(params[:q])
  end
  
  def total_sushi_count
    saved_counters.joins(:sushi_item_counters).sum("sushi_item_counters.count")
  end
  
  def top_stores(limit)
    store_counts = saved_counters.where.not(store_name: [nil, ""]).group(:store_name).count
    rank_items(store_counts.sort_by { |_, c| -c }, limit)
  end
  
  def top_sushis(limit)
    counts = saved_counters
      .joins(sushi_item_counters: :sushi_item)
      .where.not(sushi_item_counters: { count: [nil, "0"] })
      .group("sushi_items.name")
      .sum("sushi_item_counters.count")
  
    rank_items(counts.sort_by { |_, c| -c }, limit)
  end
  
  def ranked_sushis
    scope = filtered_ransack_scope.result
      .joins(sushi_item_counters: :sushi_item)
      .where.not(sushi_item_counters: { count: [nil, "0"] })
      .group("sushi_items.name")
      .select("sushi_items.name, SUM(sushi_item_counters.count) AS total_count")
  
    if (gteq = params.dig(:q, :total_count_gteq)).present?
      scope = scope.having("SUM(sushi_item_counters.count) >= ?", gteq)
    end
    if (lteq = params.dig(:q, :total_count_lteq)).present?
      scope = scope.having("SUM(sushi_item_counters.count) <= ?", lteq)
    end
  
    order_sql = {
      /total_count ASC/ => "total_count ASC",
      /total_count DESC/ => "total_count DESC",
      /name ASC/ => "sushi_items.name ASC",
      /name DESC/ => "sushi_items.name DESC"
    }.find { |regex, _| regex.match?(sushi_sort_order(params[:sort])) }&.last || "total_count DESC"
  
    scope.order(order_sql).each_with_object([]).with_index(1) do |(record, arr), pos|
      count = record.total_count.to_i
      prev = arr.last
      rank = prev && prev[:count] == count ? prev[:rank] : pos
      arr << { rank: rank, name: record.name, count: count }
    end
  end
  
  def rank_items(sorted_counts, limit)
    ranked = []
    rank = 0
    position = 0
    last_count = nil
  
    sorted_counts.each do |name, count|
      position += 1
      rank = position if count != last_count
      last_count = count
      break if rank > limit
      ranked << [name, count, rank]
    end
  
    ranked
  end
end
