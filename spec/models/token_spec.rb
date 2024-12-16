require 'rails_helper'

RSpec.describe Token, type: :model do
  let(:user) { create(:user) }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "callbacks" do
    let(:token) { build(:token, user: user) }

    it "sets expiration time before creation" do
      expect(token.expires_at).to be_nil
      token.save!
      expect(token.expires_at).not_to be_nil
      expect(token.expires_at).to be_within(5.seconds).of(30.days.from_now)
    end
  end

  describe "token generation" do
    let(:token) { create(:token, user: user) }

    it "automatically generates a secure token after creation" do
      expect(token.token).to be_present
      expect(token.token.length).to be > 10
    end
  end

  describe "#expired?" do
    let(:token) { create(:token, user: user) }

    context "when token has not expired" do
      it "returns false" do
        expect(token.expired?).to be false
      end
    end

    context "when token has expired" do
      before do
        token.update!(expires_at: 1.hour.ago)
      end

      it "returns true" do
        expect(token.expired?).to be true
      end
    end
  end
end
