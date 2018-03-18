require_relative '../acceptance_helper'
 
 feature 'Add files to question', %q{
   As an author of question
   I want to be able to attach files
 } do
   
   given(:user) { create(:user) }

   background do
     sign_in(user)
     visit new_question_path
     fill_in 'Title', with: 'Test question title'
     fill_in 'Body', with: 'test text'
   end
   
   scenario 'User adds file when asks question' do
     attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
     click_on 'Create'

     expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
   end
   
   scenario 'User adds several files', js: true do
     attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
     click_on 'Add File'
     within page.all('.file-form').last do
       attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
     end
     
     click_on 'Create'

     expect(page).to have_link 'spec_helper.rb', count: 2
   end
 end
