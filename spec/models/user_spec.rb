require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:tokens).dependent(:destroy) }
  end

  describe "Validations" do
    context "with valid attributes" do
      let(:user) { build(:user) }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "without a username" do
      let(:user) { build(:user, username: nil) }

      it "is not valid" do
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("can't be blank")
      end
    end

    context "with a duplicate username" do
      before { create(:user, username: "testuser") }
      let(:user) { build(:user, username: "testuser") }

      it "is not valid" do
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("has already been taken")
      end
    end

    context "with password and password_confirmation not matching" do
      let(:user) { build(:user, password: "password", password_confirmation: "wrongpassword") }

      it "is not valid" do
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end
    end

    context "without a password" do
      let(:user) { build(:user, password: nil, password_confirmation: nil) }

      it "is not valid" do
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end
    end
  end
end
