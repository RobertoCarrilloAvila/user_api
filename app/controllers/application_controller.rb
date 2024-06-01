# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonResponse

  rescue_from StandardError, with: :handle_standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  private

  def handle_record_not_found(exception)
    Rails.logger.error(exception)
    render json: { error: 'Record not found' }, status: :not_found
  end

  def handle_standard_error(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))

    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
end
