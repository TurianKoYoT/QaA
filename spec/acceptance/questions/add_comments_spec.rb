require_relative '../acceptance_helper'

feature 'Add comments to question', %q{
 As an authenticated user
 I want to be able to add comments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User adds comment to question', js: true do
    sign_in(user)
    visit question_path(question)

    within('.question') do
      click_on 'Add a comment'
      fill_in 'Comment', with: 'Comment body'
      click_on 'Submit comment'

      expect(page).to have_content 'Comment body'
      expect(page).to_not have_selector 'textarea'
    end

  end

  scenario 'Guest tries to add comment' do
    visit question_path(question)
    
    expect(page).to_not have_link 'Add a comment'
  end
  
  context 'multiple sessions' do
    scenario 'comment appears on another user page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.question') do
          click_on 'Add a comment'
          fill_in 'Comment', with: 'Comment body'
          click_on 'Submit comment'

          expect(page).to have_content 'Comment body'
        end
      end

      Capybara.using_session('guest') do
        within('.question') do
          expect(page).to have_content 'Comment body'
        end
      end
    end
  end
end
