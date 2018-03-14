require_relative '../acceptance_helper'
 
 feature 'Create question', %q{
   In order to get answer from community
   As an authenticated user
   I want to be able to ask questions
 } do
   
   given(:user) { create(:user) }
   
   scenario 'Authenticated user creates question' do
     sign_in(user)
     
     visit questions_path
     click_on 'Ask question'
     fill_in 'Title', with: 'Test question title'
     fill_in 'Body', with: 'test text'
     click_on "Create"
     expect(page).to have_content I18n.t('questions.create.successfull')
     expect(page).to have_content 'Test question title'
     expect(page).to have_content 'test text'
   end
   
   scenario 'User creates non valid questoin' do
     sign_in(user)
     
     visit new_question_path
     click_on "Create"
    expect(page).to have_content I18n.t('activerecord.errors.template.body')
   end
   
   scenario 'Non-authenticated user tries to create question' do
     visit questions_path
     click_on 'Ask question'
     
     expect(page).to have_content I18n.t('devise.failure.unauthenticated')
   end
 end
