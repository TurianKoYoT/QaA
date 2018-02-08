module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
  
  def check_questions_presence(questions)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
  
  def check_show_question_content_presence(question, answers)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
