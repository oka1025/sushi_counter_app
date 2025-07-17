class HealthCheckController < ApplicationController
  skip_before_action :auto_guest_sign_in

  def ping
    render plain: 'OK', status: :ok
  end
end
