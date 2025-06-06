class SushiItemsController < ApplicationController
  def new
    @sushi_item = SushiItem.new
    @categories = Category.all
  end

  def create
    @sushi_item = SushiItem.new(sushi_item_params)
    @sushi_item.created_by_user = current_user
    if @sushi_item.save
      redirect_to sushi_items_path, notice: "寿司を登録しました"
    else
      @categories = Category.all
      render :new
    end
  end

  def index
    @categories = Category.all

    category_id = params[:category_id].presence || 1
    @selected_category = Category.find_by(id: category_id)
    @sushi_items = SushiItem.includes(:sushi_item_counters, :category)
      .where(category_id: @selected_category.id)
      .where("created_by_user_id = ? OR created_by_user_id IS NULL", current_user.id)

    if user_signed_in?
      @counter = current_user.counters.order(created_at: :desc).first_or_create!(eaten_at: Time.current)
    else
      @counter = nil
    end
  end

  def edit
    @sushi_item = SushiItem.find_by(id: params[:id])

    unless @sushi_item && (
    @sushi_item.created_by_user_id == current_user.id ||
    @sushi_item.created_by_user_id.nil?
    )
      redirect_to sushi_items_path, alert: "編集権限がありません"
      return
    end

    @categories = Category.all
  end

  def update
    @sushi_item = SushiItem.find_by(id: params[:id])

    unless @sushi_item.created_by_user_id == current_user.id || @sushi_item.created_by_user_id.nil?
      redirect_to sushi_items_path, alert: "更新権限がありません"
      return
    end

    if params[:sushi_item][:reset_to_default_image] == "1"
      reset_default_image(@sushi_item)
    end

    if @sushi_item.update(sushi_item_params)
      redirect_to sushi_items_path, notice: "更新しました"
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    sushi_item = current_user.sushi_items.find(params[:id])
    sushi_item.destroy!
    redirect_to sushi_items_path, notice: "削除しました"
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

  def remove_image
    @sushi_item = current_user.sushi_items.find(params[:id])
    @sushi_item.image.purge
    redirect_to edit_sushi_item_path(@sushi_item), notice: "画像を削除しました"
  end

  private

  def sushi_item_params
    params.require(:sushi_item).permit(:name, :image, :category_id, :created_by_user)
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
