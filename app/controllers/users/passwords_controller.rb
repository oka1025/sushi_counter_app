class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :require_no_authentication

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    password_reset_done_path
  end
end
