class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, only: [:show]

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params) 
      redirect_to user_path, notice: "ユーザー名を更新しました"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def reject_guest_user
    if current_user&.guest?
      redirect_to root_path, alert: "ゲストユーザーはアクセスできません。"
    end
  end
end
