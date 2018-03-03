require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question, question_attrs.merge(user: user) }
  let(:question_attrs) { attributes_for :question }
  let(:user) { create :user }
  
  describe 'GET #index' do
    
    let(:questions) { create_list(:question, 2, user: user) }
    
    before { get :index }
    
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
  
  describe 'GET #show' do 
    before { get :show, params: { id: question } }
    
    it 'assigns the requested questions to @question' do
      expect(assigns(:question)).to eq question
    end
    
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
  
  describe 'GET #new' do
    sign_in_user
    before { get :new }
    
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do
      subject(:post_create) {
        post :create, params: { question: attributes_for(:question) }
      }
      
      it 'assigns question to user' do
        expect { post_create }.to change( user.questions, :count ).by(1)
      end
      
      it 'redirect to show view' do
        post_create
        expect(response).to redirect_to assigns(:question)
      end
    end
    
    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end
      
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template 'new'
      end
    end
  end
  
  describe 'DELETE #destroy' do
    subject(:delete_destroy) { delete :destroy, params: { id: question } }
    
    context 'as author' do
      before { sign_in(user) }
      before { question }
      
      it 'destroys question' do
        expect { delete_destroy }.to change(Question, :count).by(-1)
      end
    
      it 'redirects to index view' do
        delete_destroy
        expect(response).to redirect_to questions_path
      end
    end
    
    context 'as wrong user' do
      sign_in_as_wrong_user
      
      it 'does not destroy question' do
        question
        expect { delete_destroy }.to_not change(Question, :count)
      end
      
      it 'redirects to show view' do
        delete_destroy
        expect(response).to redirect_to assigns(:question)
      end
    end
  end
end
