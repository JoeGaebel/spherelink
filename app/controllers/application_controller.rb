class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def ensure_user_logged_in
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
