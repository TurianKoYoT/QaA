require_relative '../acceptance_helper'
 
feature 'Reset vote for answer', %q{
 As an author of vote
 I want to be able to reset it
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given!(:vote) { create(:vote, :for_answer, votable: answer, user: user) }
  
  background { sign_in(user) }
  
  scenario 'User resets vote', js: true do
    visit question_path(question)
    within('.answer') do
      click_on 'Reset Vote'
      
      expect(page).to have_content 'Rating 0'
      expect(page).to have_content '+1'
      expect(page).to have_content '-1'
      expect(page).to_not have_content 'Reset Vote'
    end
  end
end
