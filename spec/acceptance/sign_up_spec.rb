require "rails_helper"

RSpec.feature "Sign up", %q(
  As a Guest
  I want to be able to sign up
) do
  given(:user) { attributes_for :user }

  scenario "Guest is registered" do
    visit new_user_registration_path
    fill_in "Email", with: user[:email]
    fill_in "Password", with: user[:password]
    fill_in "Password confirmation", with: user[:password]

    click_on "Sign up"

    expect(current_path).to eq root_path
    expect(page).to have_content "Welcome! You have signed up successfully."
  end
end
