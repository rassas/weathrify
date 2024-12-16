require 'rails_helper'

RSpec.describe Services::Users::CreateUserAndTokenService, type: :service do
  let(:valid_username) { "john_doe" }
  let(:valid_password) { "password123" }
  let(:valid_password_confirmation) { "password123" }

  context "with valid attributes" do
    it "creates a user and a token and returns success" do
      result = described_class.new(
        username: valid_username,
        password: valid_password,
        password_confirmation: valid_password_confirmation
      ).call

      expect(result[:success]).to be true
      expect(result[:user]).to be_a(User)
      expect(result[:user].persisted?).to be true
      expect(result[:token]).to be_a(Token)
      expect(result[:token].persisted?).to be true
      expect(result[:errors]).to be_empty

      created_user = User.find_by(username: valid_username)
      expect(created_user).not_to be_nil
      expect(created_user.tokens.count).to eq(1)
    end
  end

  context "when user validation fails" do
    let(:invalid_password_confirmation) { "different_password" }

    it "returns errors and does not persist user or token" do
      result = described_class.new(
        username: valid_username,
        password: valid_password,
        password_confirmation: invalid_password_confirmation
      ).call

      expect(result[:success]).to be false
      expect(result[:user]).to be_nil
      expect(result[:token]).to be_nil
      expect(result[:errors]).not_to be_empty

      expect(User.find_by(username: valid_username)).to be_nil
    end
  end

  context "when token creation fails" do
    before do
      allow_any_instance_of(User).to receive_message_chain(:tokens, :create).and_return(Token.new)
    end

    it "rolls back and returns errors if token cannot be created" do
      result = described_class.new(
        username: valid_username,
        password: valid_password,
        password_confirmation: valid_password_confirmation
      ).call

      expect(result[:success]).to be false
      expect(result[:user]).to be_nil
      expect(result[:token]).to be_nil
      expect(result[:errors]).to include("Something went wrong! Please try again.")

      expect(User.find_by(username: valid_username)).to be_nil
    end
  end
end
