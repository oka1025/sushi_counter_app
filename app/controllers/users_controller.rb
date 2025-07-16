class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, only: [:show]

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params) 
      redirect_to user_path, notice: t('users.update_notice')
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
      redirect_to root_path, alert: t('users.guest_alert')
    end
  end
end
