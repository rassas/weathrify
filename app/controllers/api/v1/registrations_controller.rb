module Api
  module V1
    class RegistrationsController < ::Api::V1::ApplicationController
      def create
        result = Services::Users::CreateUserAndTokenService.new(
          username: params[:username],
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        ).call

        if result[:success]
          render json: {
            user: {
              id: result[:user].id,
              username: result[:user].username
            },
            token: result[:token].token
          }, status: :created
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end
    end
  end
end
