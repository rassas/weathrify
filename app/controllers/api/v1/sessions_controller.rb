module Api
  module V1
    class SessionsController < ::Api::V1::ApplicationController
      before_action :authenticate_user, only: [:destroy]

      def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
          token = user.tokens.create! # This will generate a new token
          render json: { 
            user: { id: user.id, username: user.username }, 
            token: token.token 
          }, status: :created
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      def destroy
        current_token.destroy
        render json: { message: "Signed out successfully" }, status: :ok
      end
    end
  end
end
