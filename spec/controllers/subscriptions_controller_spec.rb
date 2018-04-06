require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { sign_in(user) }
    
    subject(:post_create) { post :create, params: { question_id: question.id }, format: :js }

    it 'creates new subscription for question' do
      expect { post_create }.to change(question.subscriptions, :count).by(1)
    end

    it 'creates new subscription for user' do
      expect { post_create }.to change(user.subscriptions, :count).by(1)
    end

    it 'renders create template' do
      post_create
      expect(response).to render_template(:create)
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user_id: user.id, question_id: question.id) }
    subject(:delete_destroy) { delete :destroy, params: { id: subscription.id }, format: :js }

    before { sign_in(user) }
    
    it 'destroys subscription to question' do
      expect { delete_destroy }.to change(question.subscriptions, :count).by(-1)
    end

    it 'destroys user subscription' do
      expect { delete_destroy }.to change(user.subscriptions, :count).by(-1)
    end
  end
end
