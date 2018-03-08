require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, answer_attrs.merge(question: question, user: user) }
  let(:answer_attrs) { attributes_for :answer }
  let(:user) { create(:user) }
  
  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do
      subject(:post_create) {
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
      }
      
      it 'saves a new answer' do
        expect { post_create }.to change( question.answers, :count ).by(1)
      end
      
      it 'assigns answers to user' do
        expect { post_create }.to change( user.answers, :count ).by(1)
      end
      
      it 'renders create template' do
        post_create
        expect(response).to render_template :create
      end
    end
    
    context 'with invalid attributes' do
      subject(:post_create) {
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
      }
      
      it 'does not save answer' do
        expect { post_create }.to_not change{ Answer.count }
      end
      
      it 'redirects to question show view' do
        post_create
        expect(response).to render_template "questions/show"
      end
    end
  end
  
  describe 'DELETE #destroy' do
    subject(:delete_destroy) { delete :destroy, params: { id: answer} }
    
    context 'as author' do
      before { sign_in(user) }
      before { answer }
      
      it 'destroys answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end
      
      it 'redirects to show view' do
        delete_destroy
        expect(response).to redirect_to answer.question
      end
    end
    
    context 'as wrong user' do
      sign_in_as_wrong_user
      
      it 'does not destroy answer' do
        answer
        expect { delete_destroy }.to_not change(Answer, :count)
      end
      
      it 'redirects to show view' do
        delete_destroy
        expect(response).to redirect_to answer.question
      end
    end
  end
end
