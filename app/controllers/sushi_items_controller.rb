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
    @sushi_items = SushiItem.all
  end

  private

  def sushi_item_params
    params.require(:sushi_item).permit(:name, :image, :category_id, :cteated_by_user)
  end
end
