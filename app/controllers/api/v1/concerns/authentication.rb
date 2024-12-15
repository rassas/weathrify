module Api::V1::Concerns::Authentication
  extend ActiveSupport::Concern

  attr_reader :current_user, :current_token

  private

  def authenticate_user
    # Expecting something like: Authorization: <token>
    auth_header = request.headers['Authorization']

    if auth_header.present?
      @current_token = Token.find_by(token: auth_header)
      if @current_token && !@current_token.expired?
        @current_user = @current_token.user
      else
        render json: { error: "Token expired or invalid" }, status: :unauthorized
      end
    else
      render json: { error: "No token provided" }, status: :unauthorized
    end
  end
end
