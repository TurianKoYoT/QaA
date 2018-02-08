require 'rails_helper'

feature 'User sign out', %q{
  As an User
  I want to be able to sign out
} do
  
  given(:user) { create(:user) }
  
  scenario 'Authenticated user signs out' do
    sign_in(user)
    visit root_path
    
    click_on 'Sign out'
    
    visit new_question_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
