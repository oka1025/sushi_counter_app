class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, only: [:show]

  def show
    @user = current_user
  end

  def edit
  end

  def update
    @user = current_user
    if @user.update(user_params) 
      redirect_to user_path, notice: t('users.update_notice')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def request_email_change
    new_email = params[:user][:new_email]
    current_user.send_email_change_confirmation(new_email)
    redirect_to root_path, notice: '確認メールを送信しました。'
  end

  def confirm_email_change
    token = params[:token]
    if current_user.confirm_email_change(token)
      redirect_to root_path, notice: 'メールアドレスが変更されました。'
    else
      redirect_to root_path, alert: 'メールアドレスの変更に失敗しました。'
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
