require_relative '../acceptance_helper'

feature 'Delete question', %q{
  As an author of question
  I want to be able to delete it
} do
  
   given(:user) { create(:user) }
   given(:other_user) { create(:other_user) }
   given(:question) { create(:question, user: user) }
   
   scenario 'Author of question tries to delete his question' do
     sign_in(user)
     
     visit question_path(question)
     click_on "Delete Question"
     
     expect(page).to_not have_content question.title
     expect(current_path).to eq questions_path
   end
   
   scenario "Delete question button should be available only to author"  do
     sign_in(other_user)
     
     visit question_path(question)
     expect(page).to_not have_link "Delete Question"
   end
   
   scenario "Guest should not have delete question button" do
     visit question_path(question)
     expect(page).to_not have_link "Delete Question"
   end
end
