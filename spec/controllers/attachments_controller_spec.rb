require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, question_attrs.merge(user: user) }
  let(:question_attrs) { attributes_for :question }
  
  describe 'DELETE #destroy' do
    let(:attachment) { create(:attachment, :for_question, attachable_id: question.id) }
    subject(:delete_destroy) { delete :destroy, params: { id: attachment }, format: :js }
    before { attachment }
    
    context 'as author' do
      before { sign_in(user) }

      it 'destroys attachment' do
        expect { delete_destroy}.to change(Attachment, :count).by(-1)
      end
      
      it 'renders destroy template' do
        delete_destroy
        expect(response).to render_template :destroy
      end
    end

    context 'as wrong user' do
      sign_in_as_wrong_user

      it 'does not destroy attachment' do
        expect { delete_destroy }.to_not change(Attachment, :count)
      end

      it 'renders destroy template' do
        delete_destroy
        expect(response).to render_template :destroy
      end
    end
  end
end
