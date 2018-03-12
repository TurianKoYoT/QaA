require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  As an author of answer
  I want to be able to edit it
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:other_user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  
  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)
    
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
  
  scenario 'Author tries to edit answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Edit'
      fill_in 'Answer', with: 'edited answer'
      click_on 'Save'
      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
    end
    expect(page).to have_content I18n.t('answers.update.successfull')
  end
  
  scenario 'User tries to edit other user answer' do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
