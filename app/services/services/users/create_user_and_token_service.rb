module Services
  module Users
    class CreateUserAndTokenService
      attr_reader :username, :password, :password_confirmation, :user, :token

      def initialize(username:, password:, password_confirmation:)
        @username = username
        @password = password
        @password_confirmation = password_confirmation
      end

      # Returns a hash like:
      # {
      #   success: Boolean,
      #   user: User or nil,
      #   token: Token or nil,
      #   errors: Array of error messages if any
      # }
      def call
        ActiveRecord::Base.transaction do
          @user = User.new(username: username, password: password, password_confirmation: password_confirmation)
          unless user.save
            raise ActiveRecord::Rollback
          end

          @token = user.tokens.create
          unless token.persisted?
            # If token fails to persist, rollback
            user.errors.add(:base, "Something went wrong! Please try again.") 
            raise ActiveRecord::Rollback
          end
        end

        if user.persisted?
          { success: true, user: user, token: token, errors: [] }
        else
          { success: false, user: nil, token: nil, errors: user.errors.full_messages }
        end
      end
    end
  end
end
