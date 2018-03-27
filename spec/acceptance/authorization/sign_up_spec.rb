require_relative '../acceptance_helper'

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

    open_email(user[:email])
    expect(current_email).to have_content 'Confirm my account'
  end
end
