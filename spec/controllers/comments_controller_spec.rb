require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do
      subject(:post_create) {
        post :create, params: { comment: { body: 'body', commentable_type: "question", commentable_id: question.id }, format: :js }
      }
      
      it 'saves a new comment' do
        expect { post_create }.to change(question.comments, :count).by(1)
      end
      
      it 'assigns comment to user' do
        expect { post_create }.to change(user.comments, :count).by(1)
      end
      
      it 'renders create template' do
        post_create
        expect(response).to render_template :create
      end
    end
    
    context 'with invalid attributes' do
      subject(:post_create) {
        post :create, params: { comment: { body: '', commentable_type: "question", commentable_id: question.id }, format: :js }
      }
      
      it 'does not save a comment' do
        expect { post_create }.to_not change(Comment, :count)
      end
      
      it 'renders create template' do
        post_create
        expect(response).to render_template :create
      end
    end
  end
end
