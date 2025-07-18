# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :auto_guest_sign_in, only: [:new]
  skip_before_action :require_no_authentication, only: [:new]

  def new
    sign_out(current_user) if current_user&.guest?
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
