require_relative '../acceptance_helper'
 
feature 'User can search', %q{
  As an user
  I want to be able to search
} do
  context 'in location' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }
    given!(:answer) { create :answer }
    given!(:comment) { create :comment, commentable: question }
  
    scenario 'with invalid query', sphinx: true do
      ThinkingSphinx::Test.run do
        visit search_index_path

        fill_in 'Search for', with: 'Foobar'
        select 'Users', from: 'Type'
        click_on 'Find'

        expect(page).not_to have_content(user.email)
        expect(page).not_to have_content(question.title)
        [question, answer, comment].each do |object|
          expect(page).not_to have_content(object.body)
        end
      end
    end

    scenario 'questions', sphinx: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Search for', with: question.title
        select 'Questions', from: 'Type'
        click_on 'Find'

        expect(page).to have_content(question.title)
      end
    end

    scenario 'in answers', sphinx: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Search for', with: answer.body
        select 'Answers', from: 'Type'
        click_on 'Find'

        expect(page).to have_content(answer.body)
      end
    end

    scenario 'in comments', sphinx: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Search for', with: comment.body
        select 'Comments', from: 'Type'
        click_on 'Find'

        expect(page).to have_content(comment.body)
      end
    end

    scenario 'in users', sphinx: true do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Search for', with: user.email
        select 'Users', from: 'Type'
        click_on 'Find'

        expect(page).to have_content(user.email)
      end
    end
  end

  context 'everywhere', sphinx: true do
    given!(:question) { create(:question, title: 'everywhere question') }
    given!(:answer) { create(:answer, body: 'everywhere answer') }
    given!(:comment) { create(:comment, body: 'everywhere comment', commentable: question) }
    given!(:user) { create(:user, email: 'everywhere@example.con') }

    scenario 'search' do
      ThinkingSphinx::Test.run do
        visit search_index_path
        fill_in 'Search for', with: 'everywhere'
        select 'Everywhere', from: 'Type'
        click_on 'Find'

        expect(page).to have_content(question.title)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
      end
    end
  end
end
