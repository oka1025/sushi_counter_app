class UserMailer < ApplicationMailer
  def email_change_confirmation(user)
    @user = user
    @url = confirm_email_change_url(token: user.email_change_token)
    mail(to: user.unconfirmed_email, subject: 'メールアドレス変更の確認')
  end
end
