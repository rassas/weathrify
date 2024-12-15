require 'rails_helper'

RSpec.describe "User Registration", type: :system do
  describe "Sign Up" do
    context "when valid details are provided" do
      it "creates a new user and signs them in" do
        visit new_registration_path

        fill_in "Username", with: "newuser"
        fill_in "Password", with: "password123"
        fill_in "Password confirmation", with: "password123"
        click_button "Sign Up"

        expect(page).to have_content("Signed up successfully")
        expect(page).to have_current_path(root_path)
      end
    end

    context "when invalid details are provided" do
      it "displays an error message and renders the form" do
        visit new_registration_path

        fill_in "Username", with: ""
        fill_in "Password", with: "password123"
        fill_in "Password confirmation", with: "password123"
        click_button "Sign Up"

        expect(page).to have_content("User not created")
      end

      it "displays an error when passwords do not match" do
        visit new_registration_path

        fill_in "Username", with: "newuser"
        fill_in "Password", with: "password123"
        fill_in "Password confirmation", with: "wrongpassword"
        click_button "Sign Up"

        expect(page).to have_content("User not created")
      end
    end
  end
end
