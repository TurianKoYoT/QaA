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
      
      it 'renders create template' do
        post_create
        expect(response).to render_template :create
      end
    end
  end
  
  describe 'DELETE #destroy' do
    subject(:delete_destroy) { delete :destroy, params: { id: answer}, format: :js }
    
    context 'as author' do
      before { sign_in(user) }
      before { answer }
      
      it 'destroys answer' do
        expect { delete_destroy }.to change(Answer, :count).by(-1)
      end
      
      it 'renders destroy template' do
        delete_destroy
        expect(response).to render_template :destroy
      end
    end
    
    context 'as wrong user' do
      sign_in_as_wrong_user
      
      it 'does not destroy answer' do
        answer
        expect { delete_destroy }.to_not change(Answer, :count)
      end
      
      it 'renders destroy template' do
        delete_destroy
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    subject(:patch_update) { patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer),  format: :js } }
    subject(:patch_update_new_body) { patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' }, format: :js } }
    
    context 'as author' do
      before { sign_in(user) }
      
      it 'assigns answer to @answer' do
        patch_update
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch_update_new_body
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      
      it 'renders update template' do
        patch_update
        expect(response).to render_template :update
      end
    end

    context 'as wrong user' do
      sign_in_as_wrong_user
      
      it 'does not change answer' do
        body = answer.body
        patch_update_new_body
        answer.reload
        expect(answer.body).to eq body
      end
      
      it 'renders update template' do
        patch_update
        expect(response).to render_template :update
      end
    end
  end
  
  describe 'POST #choose_best_answer' do
    subject(:post_choose_best) { post :choose_best, params: {id: answer, answer: attributes_for(:answer), format: :js} }

    context 'as author' do
      before { sign_in(user) }
    
      it 'assigns answer to @answer' do
        post_choose_best
        expect(assigns(:answer)).to eq answer
      end
      
      it 'sets answer as best' do
        post_choose_best
        answer.reload
        expect(answer.best).to eq true
      end
      
      it 'renders choose_best template' do
        post_choose_best
        expect(response).to render_template :choose_best
      end
    end
    
    context 'not as author' do
      sign_in_as_wrong_user
      
      it 'does not set best answer' do
        best = answer.best
        post_choose_best
        answer.reload
        expect(answer.best).to eq false
      end
      
      it 'renders choose_best template' do
        post_choose_best
        expect(response).to render_template :choose_best
      end
    end
  end
end
