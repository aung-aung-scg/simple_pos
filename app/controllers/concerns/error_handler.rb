module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_error_response
  end

  def render_error_response(exception)
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "error_explanation",
          partial: "shared/error_messages",
          locals: { object: exception.record }
        )
      }
      format.json { render json: { errors: exception.record.errors }, status: :unprocessable_entity }
    end
  end
end
