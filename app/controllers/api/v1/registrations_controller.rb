module Api
  module V1
    class RegistrationsController < ::Api::V1::ApplicationController
      def create
        user = User.new(registration_params)
        if user.save
          token = user.tokens.create!
          render json: { 
            user: { id: user.id, username: user.username }, 
            token: token.token 
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def registration_params
        params.permit(:username, :password, :password_confirmation)
      end
    end
  end
end
