module Api
  module V1
    class SessionsController < ::Api::V1::ApplicationController
      before_action :authenticate_user, only: [ :destroy ]

      def create
        service = ::Services::Users::SignInService.new(username: params[:username], password: params[:password])
        result = service.call

        if result[:success]
          render json: {
            user: { id: result[:user].id, username: result[:user].username },
            token: result[:token].token
          }, status: :created
        else
          render json: { errors: result[:errors] }, status: :unauthorized
        end
      end

      def destroy
        current_token.destroy
        render json: { message: "Signed out successfully" }, status: :ok
      end
    end
  end
end
