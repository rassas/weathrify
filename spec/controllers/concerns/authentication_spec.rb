require "rails_helper"

RSpec.describe Authentication, type: :controller do
  controller(ApplicationController) do
    include Authentication

    def index
      render plain: "Hello, world!"
    end
  end

  let(:user) { create(:user) }

  describe "#current_user" do
    context "when user is signed in" do
      before { session[:user_id] = user.id }

      it "returns the current user" do
        expect(controller.send(:current_user)).to eq(user)
      end
    end

    context "when no user is signed in" do
      before { session[:user_id] = nil }

      it "returns nil" do
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end

  describe "#user_signed_in?" do
    context "when user is signed in" do
      before { session[:user_id] = user.id }

      it "returns true" do
        expect(controller.send(:user_signed_in?)).to be(true)
      end
    end

    context "when no user is signed in" do
      before { session[:user_id] = nil }

      it "returns false" do
        expect(controller.send(:user_signed_in?)).to be(false)
      end
    end
  end

  describe "#authenticate_user!" do
    controller(ApplicationController) do
      include Authentication

      before_action :authenticate_user!, only: :protected_action

      def protected_action
        render plain: "Protected!"
      end
    end

    before do
      routes.draw { get "protected_action" => "anonymous#protected_action" }
    end

    context "when user is signed in" do
      before do
        session[:user_id] = user.id
        get :protected_action
      end

      it "allows access to the action" do
        expect(response.body).to eq("Protected!")
      end
    end

    context "when no user is signed in" do
      let(:new_session_path) { "/users/sign_in" }

      before { get :protected_action }

      it "redirects to the sign-in page" do
        expect(response).to redirect_to(new_session_path)
      end

      it "sets a flash notice" do
        expect(flash[:notice]).to eq("Sign In first!")
      end
    end
  end

  describe "#sign_in" do
    it "sets the session user_id" do
      controller.send(:sign_in, user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe "#sign_out" do
    before { session[:user_id] = user.id }

    it "clears the session user_id" do
      controller.send(:sign_out)
      expect(session[:user_id]).to be_nil
    end
  end
end
