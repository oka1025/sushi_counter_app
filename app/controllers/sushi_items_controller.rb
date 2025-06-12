class SushiItemsController < ApplicationController
  before_action :selected_category, only: %i[index new create edit update]

  def index
    @sushi_items = SushiItem.includes(:sushi_item_counters, :category)
      .where(category_id: @selected_category.id)
      .where("created_by_user_id = ? OR created_by_user_id IS NULL", current_user.id)
    
    respond_to do |format|
      format.turbo_stream if turbo_frame_request?
      format.html
    end

    if user_signed_in?
      @counter = current_counter || current_user.counters.create!(eaten_at: Time.current)
      set_current_counter(@counter)
    else
      @counter = nil
    end
  end
  

  def new
    @sushi_item = SushiItem.new
    @return_category_id = params[:return_category_id] || 1
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @return_category_id = params[:return_category_id] || sushi_item_params[:category_id]

    @sushi_item = SushiItem.new(sushi_item_params)
    @sushi_item.created_by_user = current_user
    @counter = current_user.counters.order(created_at: :desc).first_or_create!(eaten_at: Time.current)

    if @sushi_item.save
      @sushi_items = SushiItem.includes(:sushi_item_counters, :category)
        .where(category_id: @return_category_id)
      respond_to do |format|
        format.html { redirect_to sushi_items_path(category_id: @return_category_id), notice: "寿司を作成しました" }
        format.turbo_stream 
      end
    else
      @categories = Category.all
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @sushi_item = SushiItem.find_by(id: params[:id])
    @sushi_items = SushiItem.includes(:sushi_item_counters, :category)
      .where(category_id: @selected_category.id)

    unless @sushi_item && (
    @sushi_item.created_by_user_id == current_user.id ||
    @sushi_item.created_by_user_id.nil?
    )
      redirect_to sushi_items_path, alert: "編集権限がありません"
      return
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    @sushi_item = SushiItem.find_by(id: params[:id])
    @counter = current_user.counters.order(created_at: :desc).first_or_create!(eaten_at: Time.current)

    unless @sushi_item.created_by_user_id == current_user.id || @sushi_item.created_by_user_id.nil?
      redirect_to sushi_items_path, alert: "更新権限がありません"
      return
    end

    if params[:sushi_item][:reset_to_default_image] == "1"
      reset_default_image(@sushi_item)
    end

    if @sushi_item.update(sushi_item_params)
      @sushi_items = SushiItem.includes(:sushi_item_counters, :category)
                              .where(category_id: @selected_category.id)

      respond_to do |format|
          format.turbo_stream 
          format.html { redirect_to sushi_items_path(category_id: category_id), notice: "更新しました" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sushi_item = current_user.sushi_items.find(params[:id])
    @sushi_item.destroy

    @selected_category = @sushi_item.category
    @categories = Category.all
    @counter = current_user.counters.order(created_at: :desc).first

    @sushi_items = SushiItem.includes(:category, :sushi_item_counters)
                            .where(category_id: @selected_category.id)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to sushi_items_path(category_id: @selected_category.id), notice: '削除しました' }
    end
  end

  def update_count
    @sushi_item = SushiItem.find(params[:id])
    @counter = current_user.counters.order(created_at: :desc).first_or_create!(eaten_at: Time.current)

    sushi_counter = @sushi_item.sushi_item_counters.find_or_initialize_by(counter_id: @counter.id)
    sushi_counter.count ||= 0

    if params[:direction] == "increment"
      sushi_counter.count += 1
    elsif params[:direction] == "decrement"
      sushi_counter.count = [sushi_counter.count - 1, 0].max
    end

    sushi_counter.save!

    respond_to do |format|
      format.turbo_stream
      format.js # fallback
      format.html { redirect_to sushi_items_path }
    end
  end

  private

  def sushi_item_params
    params.require(:sushi_item).permit(:name, :image, :category_id, :created_by_user, :remove_image)
  end

  def selected_category
    @categories = Category.all
    category_id = params[:category_id].presence || params[:return_category_id].presence || 1
    @selected_category = Category.find_by(id: category_id)
  end


  def reset_default_image(sushi)
    default_filename = {
      "まぐろ" => "maguro.png",
      "とろびんちょう" => "bincho.png"
    }[sushi.name]

    return unless default_filename

    path = Rails.root.join("app/assets/images/seeds/#{default_filename}")
    if File.exist?(path)
      sushi.image.purge
      sushi.image.attach(
        io: File.open(path),
        filename: default_filename,
        content_type: "image/png"
      ) 
    end
  end
end
