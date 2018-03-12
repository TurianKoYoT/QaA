require_relative '../acceptance_helper'

feature 'List all questions', %q{
  As an user or guest
  I want to be able to see list of all questions
} do
  
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2) }
  
  scenario 'Authenticated user sees all questions' do
    sign_in(user)
      
    check_questions_presence(questions)
  end
  
  scenario 'Guest sees all questions' do
    check_questions_presence(questions)
  end
end
