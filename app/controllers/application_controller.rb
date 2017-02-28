class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render json: { error: "record not found" }, status: 404
  end
end
