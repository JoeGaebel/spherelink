class ApplicationController < ActionController::Base
  include ActionView::Helpers::SanitizeHelper

  protect_from_forgery with: :exception

  private

  def booleanify(str)
    str == 'true'
  end

  def is_boolean?(value)
    [true, false].include? value
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def render_model_errors(model)
    render json: { message: model.errors.full_messages.join(', ') }, status: :bad_request
  end

  def render_not_found
    render json: { message: 'not found' }, status: :not_found
  end
end
