require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "is valid with valid attributes" do
      user = User.new(username: "testuser", password: "password", password_confirmation: "password")
      expect(user).to be_valid
    end

    it "is not valid without a username" do
      user = User.new(username: nil, password: "password", password_confirmation: "password")
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it "is not valid with a duplicate username" do
      User.create!(username: "testuser", password: "password", password_confirmation: "password")
      user = User.new(username: "testuser", password: "password", password_confirmation: "password")
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("has already been taken")
    end

    it "is not valid if password and password_confirmation do not match" do
      user = User.new(username: "testuser", password: "password", password_confirmation: "wrongpassword")
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it "is not valid without a password" do
      user = User.new(username: "testuser", password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end
  end
end
