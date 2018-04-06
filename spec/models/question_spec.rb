require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of :title}
  it { should validate_presence_of :body}
  it { should validate_length_of(:title).is_at_most(48) }
  it { should validate_length_of(:body).is_at_most(2000) }
  
  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Votable'

  describe '#subscribe_author' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'subscribe author to question' do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end

    it 'performed after question created' do
      expect(question).to receive(:subscribe_author)
      question.save!
    end
  end
end
