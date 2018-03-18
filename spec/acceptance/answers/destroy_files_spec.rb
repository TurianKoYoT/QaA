require_relative '../acceptance_helper'
 
 feature 'Add files to question', %q{
   As an author of answer
   I want to be able to destroy attachments
 } do
   
  given(:user) { create(:user) }
  given(:other_user) { create(:other_user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, :for_answer, attachable_id: answer.id ) }

  scenario 'Author destroys attachment', js: true do
    sign_in(user)
    visit question_path(question)

    within(".attachment-#{attachment.id}") do
      click_on "Delete file"
    end

    within(".answers") do
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'Non-author tries to destroy attachment' do
    sign_in(other_user)
    visit question_path(question)

    within(".answers") do
      expect(page).to_not have_content 'Delete file'
    end
  end

  scenario 'Guest tries to destroy attachment' do
    visit question_path(question)

    within(".answers") do
      expect(page).to_not have_content 'Delete file'
    end
  end
end
