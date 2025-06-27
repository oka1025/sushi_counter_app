class UserGachaListsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, only: [:index]

  def index
    @all_gacha_lists = GachaList.all.with_attached_image.order(:id)
    @owned_gacha_list_ids = current_user.user_gacha_lists
      .select(:gacha_list_id)
      .distinct.pluck(:gacha_list_id)
  end

  private

  def reject_guest_user
    if current_user&.guest?
      redirect_to gachas_path, alert: "ゲストユーザーはアクセスできません。"
    end
  end
end
