require 'rails_helper'

RSpec.describe Services::Users::SignInService, type: :service do
  let(:user) { create(:user) }
  let(:username) { user.username }
  let(:password) { user.password }

  context "with valid credentials" do
    it "returns success, user, and token" do
      result = described_class.new(username: username, password: password).call

      expect(result[:success]).to be true
      expect(result[:user]).to eq(user)
      expect(result[:token]).to be_a(Token)
      expect(result[:token].persisted?).to be true
      expect(result[:errors]).to be_empty
    end
  end

  context "with invalid username" do
    it "returns failure and error message" do
      result = described_class.new(username: "invalid_user", password: password).call

      expect(result[:success]).to be false
      expect(result[:user]).to be_nil
      expect(result[:token]).to be_nil
      expect(result[:errors]).to include("Invalid credentials")
    end
  end

  context "with invalid password" do
    it "returns failure and error message" do
      result = described_class.new(username: username, password: "wrongpassword").call

      expect(result[:success]).to be false
      expect(result[:user]).to be_nil
      expect(result[:token]).to be_nil
      expect(result[:errors]).to include("Invalid credentials")
    end
  end

  context "when token creation fails" do
    before do
      allow_any_instance_of(User).to receive_message_chain(:tokens, :create).and_return(Token.new)
    end

    it "returns failure and error message" do
      result = described_class.new(username: username, password: password).call

      expect(result[:success]).to be false
      expect(result[:user]).to be_nil
      expect(result[:token]).to be_nil
      expect(result[:errors]).to include("Something went wrong! Please try again.")
    end
  end
end
