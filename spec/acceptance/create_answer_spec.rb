require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to answer questions
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  scenario 'Authenticated user creates answer to question' do
    sign_in(user)
    
    visit question_path(question.id)
    fill_in 'Answer text', with: 'helpful answer'
    click_on "Submit"
    expect(page).to have_content I18n.t('answers.create.successfull')
    expect(page).to have_content 'helpful answer'
  end
  
  scenario 'User tries to create non-valid answer' do
    sign_in(user)
    
    visit question_path(question.id)
    click_on "Submit"
    expect(page).to have_content I18n.t('activerecord.errors.template.body')
  end
  
  scenario 'Non-authenticated user tries to create answer'do
    visit question_path(question.id)
    expect(page).to have_content I18n.t('answers.create.not_signed_in')
  end
end
