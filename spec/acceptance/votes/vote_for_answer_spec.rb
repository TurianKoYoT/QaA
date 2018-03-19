require_relative '../acceptance_helper'
 
feature 'Vote for answer', %q{
 As an authenticated user
 I want to be able to vote for answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:other_user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: other_user, question: question) }

  context 'User is not an author' do
    background do
      sign_in(user)
    end
    
    scenario 'Authenticated user votes up for answer', js: true do
      visit question_path(question)
      within('.answers') do
        click_on '+1'

        expect(page).to have_content 'Rating 1'
        
        expect(page).to_not have_link '+1'
        expect(page).to_not have_link '-1'
      end
    end

    scenario 'Authenticated user votes down for question', js: true do
      visit question_path(question)
      within('.answers') do
        click_on '-1'

        expect(page).to have_content 'Rating -1'

        expect(page).to_not have_link '+1'
        expect(page).to_not have_link '-1'
      end
    end

    scenario 'User already voted' do
      create(:vote, :for_answer, votable: answer, user: user)

      visit question_path(question)
      within('.answers') do
        expect(page).to_not have_link '+1'
        expect(page).to_not have_link '-1'
      end
    end
  end
  
  context 'User is author' do
    background do
      sign_in(other_user)
    end
    
    scenario 'User can not vote' do
      visit question_path(question)
      within('.answers') do
        expect(page).to_not have_link '+1'
        expect(page).to_not have_link '-1'
        expect(page).to_not have_link 'Reset Vote'
      end
    end
  end
  
  context 'Non authorized' do
    scenario 'User can not vote' do
      visit question_path(question)
      within('.answers') do
        expect(page).to_not have_link '+1'
        expect(page).to_not have_link '-1'
        expect(page).to_not have_link 'Reset Vote'
      end
    end
  end
end
