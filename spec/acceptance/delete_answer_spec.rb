require 'rails_helper'

feature 'Delete answer', %q{
  As an author of answers
  I want to be able to delete it
} do
  
  given(:user) { create(:user) }
  given(:other_user) { create(:other_user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  
  scenario 'Author of answer tries to delete his answer' do
    sign_in(user)
    
    visit question_path(question)
    click_on "Delete Answer"
    
    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(question)
  end
  
  scenario "Delete answer button should be available only to author" do
    sign_in(other_user)
    
    visit question_path(question)
    expect(page).to_not have_link "Delete Answer"
  end
  
  scenario "Guest should not have delete answer button" do
    visit question_path(question)
    expect(page).to_not have_link "Delete Answer"
  end
end
