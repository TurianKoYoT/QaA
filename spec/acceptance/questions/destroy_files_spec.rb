require_relative '../acceptance_helper'
 
 feature 'Add files to question', %q{
   As an author of question
   I want to be able to destroy attachments
 } do
   
   given(:user) { create(:user) }
   given(:other_user) { create(:other_user) }
   given(:question) { create(:question, user: user) }
   given!(:attachment) { create(:attachment, :for_question, attachable_id: question.id ) }

   scenario 'Author destroys attachment', js: true do
     sign_in(user)
     visit question_path(question)

     within(".attachment-#{attachment.id}") do
       click_on "Delete file"
     end

     expect(page).to_not have_link 'spec_helper.rb'
   end

   scenario 'Non-author tries to destroy attachment' do
     sign_in(other_user)
     visit question_path(question)

     expect(page).to_not have_content 'Delete file'
   end

   scenario 'Guest tries to destroy attachment' do
     visit question_path(question)

    expect(page).to_not have_content 'Delete file'
   end
 end
