require_relative '../acceptance_helper'

feature 'Add comments to answer', %q{
 As an authenticated user
 I want to be able to add comments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'User adds comment to answer', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answers') do
      click_on 'Add a comment'
      fill_in 'Comment', with: 'Comment body'
      click_on 'Submit comment'

      expect(page).to have_content 'Comment body'
      expect(page).to_not have_selector 'textarea'
    end

  end

  scenario 'Guest tries to add comment' do
    visit question_path(question)
    
    within('.answers') do
      expect(page).to_not have_link 'Add a comment'
    end
  end
end
