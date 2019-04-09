module Api::V1
  class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

    def render_not_found(exception)
      logger.info(exception)
      render json: { error: I18n.t('api.errors.not_found') }, status: :not_found
    end

    def render_record_invalid(exception)
      logger.info(exception)
      render json: { errors: exception.record.errors.as_json }, status: :unprocessable_entity
    end
  end
end
