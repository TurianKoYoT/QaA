require_relative '../acceptance_helper'
 
 feature 'Select best answer', %q{
   As an author of question
   I want to be able to pick best answer
 } do

   given(:user) { create(:user) }
   given(:other_user) { create(:other_user) }
   given(:question) { create(:question, user: user) }
   given!(:answer) { create(:answer, question: question) }
   given!(:second_answer) { create(:answer, question: question) }
   
   scenario 'Author picks best answer', js: true do
     sign_in(user)
     
     visit question_path(question)

     within(".answer-#{answer.id}") do
       click_on 'Choose as best answer'
       expect(page).to have_content 'Best Answer'
     end
   end
   
   scenario 'User tries to select best answer for other user question' do
     sign_in(other_user)
     
     visit question_path(question)
     
     expect(page).to_not have_content 'Choose as best answer'
   end
   
   scenario 'Guest tries to select best answer' do
     visit question_path(question)
     
     expect(page).to_not have_content 'Choose as best answer'
   end
   
   scenario 'Author picks another answer as best', js: true do
     answer.update(best: true)
     
     sign_in(user)

     visit question_path(question)

     within(".answer-#{answer.id}") do
       expect(page).to have_content 'Best Answer'
     end
     
     within(".answer-#{second_answer.id}") do
       click_on 'Choose as best answer'
       expect(page).to have_content 'Best Answer'
     end
     
     within(".answer-#{answer.id}") do
       expect(page).to_not have_content 'Best Answer'
     end
   end
   
   scenario 'Newly picked answer comes first at list', js: true do
     answer.update(best: true)
     
     sign_in(user)

     visit question_path(question)
     
     expect(first(".answer")).to eq find(".answer-#{answer.id}")
    
     within(".answer-#{second_answer.id}") do
       click_on 'Choose as best answer'
     end
     
     sleep(1)
     expect(find(".answer", match: :first)).to eq find(".answer-#{second_answer.id}")
   end
 end
