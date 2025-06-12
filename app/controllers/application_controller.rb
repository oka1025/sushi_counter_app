class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_counter
    @current_counter ||= begin
      if session[:current_counter_id]
        current_user.counters.find_by(id: session[:current_counter_id])
      end
    end
  end
  
  def set_current_counter(counter)
    session[:current_counter_id] = counter.id
  end
  
  def clear_current_counter
    session.delete(:current_counter_id)
  end


  protected

  def configure_permitted_parameters
    added_attrs = [ :name, :email, :password, ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  end
end
