require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    
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
    before { get :new }
    
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    context 'with valid attributes' do
      subject(:post_create) {
        post :create, params: { question: attributes_for(:question) }
      }
      
      it 'saves the new question' do
        expect { post_create }.to change(Question, :count).by(1)
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
end
