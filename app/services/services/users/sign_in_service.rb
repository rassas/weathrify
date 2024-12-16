module Services
  module Users
    class SignInService
      attr_reader :username, :password, :user, :token, :errors

      def initialize(username:, password:)
        @username = username
        @password = password
        @errors = []
      end

      # Returns a hash like:
      # {
      #   success: Boolean,
      #   user: User or nil,
      #   token: Token or nil,
      #   errors: Array of error messages if any
      # }
      def call
        @user = User.find_by(username: username)
        unless user&.authenticate(password)
          @errors << "Invalid credentials"
          return failure_response
        end

        @token = user.tokens.create
        unless token.persisted?
          @errors << "Something went wrong! Please try again."
          return failure_response
        end

        success_response
      end

      private

      def success_response
        {
          success: true,
          user: user,
          token: token,
          errors: []
        }
      end

      def failure_response
        {
          success: false,
          user: nil,
          token: nil,
          errors: errors
        }
      end
    end
  end
end
