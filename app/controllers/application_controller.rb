class ApplicationController < ActionController::API
  respond_to :json

  rescue_from StandardError, with: :render_internal_server_error_response
  rescue_from AccessGranted::AccessDenied, with: :render_unauthorized_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::StatementInvalid, with: :render_db_error_response
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ApiException, with: :render_api_response

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role])
  end

  private

  def render_unauthorized_response(exception)
    render json: {message: exception.message}, status: :unauthorized
  end

  def render_unprocessable_entity_response(exception)
    render json: {
      message: exception.record.errors.full_messages.to_sentence,
      errors: ValidationErrorsSerializer.new(exception.record).serialize
    }, status: :unprocessable_entity
  end

  def render_db_error_response
    render json: {message: exception.message}, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: {message: exception.message}, status: :not_found
  end

  def render_api_response(exception)
    render json: {message: exception.message, detail: exception.detail, code: exception.code}, status: :not_acceptable
  end

  def render_internal_server_error_response(exception)
    Rails.logger.error exception.message
    Rails.logger.debug exception.backtrace.join("\n")
    render json: {message: "Something Went Wrong"}, status: :internal_server_error
  end
end
