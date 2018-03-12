require_relative '../acceptance_helper'

feature 'Show question', %q{
  As an user
  I want to be able to see question and all answers to it
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list :answer, 2, question: question }
  
  scenario 'Authenticated user sees question' do
    sign_in(user)
    
    visit question_path(question.id)
    check_show_question_content_presence(question, answers)
  end
  
  scenario 'Non-authenticated user sees question' do
    visit question_path(question.id)
    check_show_question_content_presence(question, answers)
  end
end
