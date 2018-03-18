require_relative '../acceptance_helper'
 
feature 'Vote for question', %q{
 As an authenticated user
 I want to be able to vote for question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:other_user) }
  given(:question) { create(:question, user: other_user) }

  context 'User is not an author' do
    background do
      sign_in(user)
    end
    
    scenario 'Authenticated user votes up for question', js: true do
      visit question_path(question)
      click_on '+1'

      expect(page).to have_content 'Rating 1'
      
      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
    end

    scenario 'Authenticated user votes down for question', js: true do
      visit question_path(question)
      click_on '-1'

      expect(page).to have_content 'Rating -1'

      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
    end

    scenario 'User already voted' do
      create(:vote, :for_question, votable: question, user: user)

      visit question_path(question)

      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
    end
  end
  
  context 'User is author' do
    background do
      sign_in(other_user)
    end
    
    scenario 'User can not vote' do
      visit question_path(question)
      
      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
      expect(page).to_not have_link 'Reset Vote'
    end
  end
  
  context 'Non authorized' do
    scenario 'User can not vote' do
      visit question_path(question)
      
      expect(page).to_not have_link '+1'
      expect(page).to_not have_link '-1'
      expect(page).to_not have_link 'Reset Vote'
    end
  end
end
