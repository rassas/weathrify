require "rails_helper"

RSpec.describe "Session Management", type: :system do
  let!(:user) { create(:user, username: "testuser", password: "password") }

  # redirecting to root_path requires mocking weather service
  include_context "Mock Weather Service"

  describe "Sign In" do
    it "signs in the user successfully with valid credentials" do
      visit new_session_path

      fill_in "Username", with: "testuser"
      fill_in "Password", with: "password"
      click_button "Sign In"

      expect(page).to have_content("Signed In successfully")
      expect(page).to have_current_path(root_path)
    end

    it "fails to sign in with invalid credentials" do
      visit new_session_path

      fill_in "Username", with: "testuser"
      fill_in "Password", with: "wrongpassword"
      click_button "Sign In"

      expect(page).to have_content("Sign In failed")
      expect(page).to have_current_path(new_session_path)
    end
  end

  describe "Sign Out" do
    it "signs out the user successfully" do
      # Sign in the user first
      visit new_session_path

      fill_in "Username", with: "testuser"
      fill_in "Password", with: "password"
      click_button "Sign In"

      # Sign out the user
      click_button "Sign Out"

      expect(page).to have_content("Signed Out successfully")
      expect(page).to have_current_path(new_session_path)
    end
  end
end
