require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  
  describe 'GET #show' do
    before { get :show, params: { id: answer } }
    
    it 'assigns the requested answer to @answer' do    
      expect(assigns(:answer)).to eq answer
    end
    
    it 'renders show view' do
      expect(response).to render_template 'show'
    end     
  end
  
  describe 'GET #new' do
    before { get :new, params: { question_id: question } }
    
    it 'assigns a new question to @question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    
    it 'renders new view' do
      expect(response).to render_template 'new'
    end
  end
  
  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:post_create) {
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
      }
      
      it 'saves a new answer' do
        expect { post_create }.to change{ question.answers.count }.by(1)
      end
      
      it 'redirects to show view' do
        post_create
        expect(response).to redirect_to assigns(:answer)
      end
    end
    
    context 'with invalid attributes' do
      subject(:post_create) {
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
      }
      
      it 'does not save answer' do
        expect { post_create }.to_not change{ Answer.count }
      end
      
      it 're-renders new view' do
        post_create
        expect(response).to render_template 'new'
      end
    end  
  end
end
