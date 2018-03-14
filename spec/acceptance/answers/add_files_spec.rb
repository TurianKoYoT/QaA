require_relative '../acceptance_helper'
 
 feature 'Add files to answer', %q{
   As an author of answer
   I want to be able to attach files
 } do
   given(:user) { create(:user) }
   given(:question) { create(:question) }

   background do
     sign_in(user)
     visit question_path(question)
     fill_in 'Answer text', with: 'Answer body'
   end

   scenario 'User adds file when submits answer', js: true do
     attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
     click_on 'Submit'

     within '.answers' do
       expect(page).to have_link 'spec_helper.rb'
     end
   end
   
   scenario 'User adds several files', js: true do
     attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
     click_on 'Add File'
     within page.all('.file-form').last do
       attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
     end
     click_on 'Submit'

     within '.answers' do
       expect(page).to have_link 'spec_helper.rb', count: 2
     end
   end
 end
