class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sushi_item

  def create
    current_user.bookmarks.create(sushi_item: @sushi_item)
    respond_to do |format|
      format.html { redirect_to sushi_item_path, notice: t('bookmarks.create_notice')}
      format.turbo_stream
    end
  end

  def destroy
    current_user.bookmarks.find_by(sushi_item: @sushi_item)&.destroy
    respond_to do |format|
      format.html { redirect_to sushi_item_path, notice: t('bookmarks.destroy_notice')}
      format.turbo_stream
    end
  end

  private

  def set_sushi_item
    @sushi_item = SushiItem.find(params[:sushi_item_id])
  end
end
