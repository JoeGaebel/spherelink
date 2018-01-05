class ApplicationController < ActionController::Base
  include ActionView::Helpers::SanitizeHelper

  protect_from_forgery with: :exception

  private

  def booleanify(str)
    str == 'true'
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
