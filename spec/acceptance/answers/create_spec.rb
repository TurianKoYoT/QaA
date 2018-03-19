require_relative '../acceptance_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to answer questions
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  scenario 'Authenticated user creates answer to question', js: true do
    sign_in(user)
    
    visit question_path(question.id)
    fill_in 'Answer text', with: 'helpful answer'
    click_on "Submit"
    expect(page).to have_content I18n.t('answers.create.successfull')
    expect(page).to have_content 'helpful answer'
  end
  
  scenario 'User tries to create non-valid answer', js: true do
    sign_in(user)
    
    visit question_path(question.id)
    click_on "Submit"
    expect(page).to have_content "Body can't be blank"
  end
  
  scenario 'Non-authenticated user tries to create answer'do
    visit question_path(question.id)
    expect(page).to have_content I18n.t('answers.create.not_signed_in')
  end

  context 'multiple sessions' do
    scenario 'answer appears on another user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Answer text', with: 'helpful answer'
        click_on "Submit"
        expect(page).to have_content 'helpful answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'helpful answer', count: 1
      end
    end
  end
end
