require_relative '../acceptance_helper'

feature 'Edit question', %q{
  As an author of question
  I want to be able to edit it
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:other_user) }
  given(:question) { create(:question, user: user) }
  
  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)
    
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
  
  scenario 'Author tries to edit question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      fill_in 'Question', with: 'edited question'
      click_on 'Save'
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea'
    end
      expect(page).to have_content I18n.t('questions.update.successfull')
  end
  
  scenario 'User tries to edit other user question' do
    sign_in(other_user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
