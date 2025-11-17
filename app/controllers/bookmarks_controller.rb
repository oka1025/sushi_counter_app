class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sushi_item

  def create
    current_user.bookmarks.create(sushi_item: @sushi_item)
    respond_to do |format|
      format.html { redirect_to sushi_item_path(@sushi_item), notice: t('bookmarks.create_notice')}
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "bookmark_button_#{@sushi_item.id}",
          partial: 'sushi_items/bookmark_buttons',
          locals: { sushi_item: @sushi_item, bookmarked_ids: current_user.bookmarks.pluck(:sushi_item_id).to_set }
        )
      end
    end
  end

  def destroy
    current_user.bookmarks.find_by(sushi_item: @sushi_item)&.destroy
    respond_to do |format|
      format.html { redirect_to sushi_item_path(@sushi_item), notice: t('bookmarks.destroy_notice')}
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "bookmark_button_#{@sushi_item.id}",
          partial: 'sushi_items/bookmark_buttons',
          locals: { sushi_item: @sushi_item, bookmarked_ids: current_user.bookmarks.pluck(:sushi_item_id).to_set }
        )
      end
    end
  end

  private

  def set_sushi_item
    @sushi_item = SushiItem.find(params[:sushi_item_id])
  end
end
