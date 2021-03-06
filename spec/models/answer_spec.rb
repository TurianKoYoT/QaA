require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
    
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_most(2000) }

  it_behaves_like 'Attachable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Votable'

  describe "choose_best" do
    let(:question) { create :question }
    let(:answer) { create(:answer, question_id: question.id) }
    let(:answer_attrs) { attributes_for :answer }

    it "set best flag for answer" do
      answer.choose_best
      expect(answer).to be_best
    end

    it "set previous best answer flag to false" do
      previous_best_answer = create(:answer, best: true, question_id: question.id)
      answer.choose_best
      previous_best_answer.reload
      expect(previous_best_answer).to_not be_best
    end
    
    it "does not change best answers for other questions" do
      another_question = create(:question)
      another_question_best = create(:answer, best: true, question_id: another_question.id)
      answer.choose_best
      another_question_best.reload
      expect(another_question_best).to be_best
    end
  end
  
  describe "#notify_subscriber" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    subject { build(:answer, question: question) }

    it 'should notify subscribed user' do
        expect(QuestionNotifierJob).to receive(:perform_later).with(subject)
        subject.save!
    end
  end
end
