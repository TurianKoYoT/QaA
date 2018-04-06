require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }

    it { is_expected.not_to be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    it { is_expected.to_not be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }

    context 'Question' do
      let(:user_question) { create(:question, user: user) }
      let(:other_user_question) { create(:question, user: other_user) }

      context 'create' do
        it { is_expected.to be_able_to :create, Question }
      end

      context 'update' do
        it { is_expected.to be_able_to :update, user_question, user: user }
        it { is_expected.to_not be_able_to :update, other_user_question, user: user }
      end

      context 'destroy' do
        it { is_expected.to be_able_to :destroy, user_question, user: user }
        it { is_expected.to_not be_able_to :destroy, other_user_question, user: other_user }
      end

      context 'voted' do
        let(:user_votable) { create(:question, user: user) }
        let(:other_user_votable) { create(:question, user: other_user) }
        it_behaves_like 'voted ability'
      end
    end

    context 'Answer' do
      let(:user_answer) { create(:answer, user: user) }
      let(:other_user_answer) { create(:answer, user: other_user) }

      context 'create' do
        it { is_expected.to be_able_to :create, Answer }
      end

      context 'update' do
        it { is_expected.to be_able_to :update, user_answer, user: user }
        it { is_expected.to_not be_able_to :update, other_user_answer, user: user }
      end

      context 'destroy' do
        it { is_expected.to be_able_to :destroy, user_answer, user: user }
        it { is_expected.to_not be_able_to :destroy, other_user_answer, user: other_user }
      end

      context 'choose_best' do
        context 'user author of question' do
          let(:user_question) { create :question, user: user }
          let(:user_answer) { create :answer, user: user, question: user_question }
          let(:other_user_answer) { create :answer, question: user_question }

          it { is_expected.to be_able_to :choose_best, other_user_answer, user: user }
          it { is_expected.to be_able_to :choose_best, user_answer, user: user }
        end

        context 'user not author of question' do
          let(:user_question) { create :question }
          let(:user_answer) { create :answer, user: user, question: user_question }
          let(:other_user_answer) { create :answer, question: user_question }

          it { is_expected.not_to be_able_to :choose_best, other_user_answer, user: user }
          it { is_expected.not_to be_able_to :choose_best, user_answer, user: user }
        end
      end

      context 'voted' do
        let(:user_votable) { create(:answer, user: user) }
        let(:other_user_votable) { create(:answer, user: other_user) }
        it_behaves_like 'voted ability'
      end
    end

    context 'Attachment' do
      let(:user_question) { create :question, user: user }
      let(:other_user_question) { create :question, user: other_user }
      let(:user_answer) { create :answer, user: user }
      let(:other_user_answer) { create :answer, user: other_user }
      let(:user_question_attachment) { create :attachment, attachable: user_question }
      let(:other_user_question_attachment) { create :attachment, attachable: other_user_question }
      let(:user_answer_attachment) { create :attachment, attachable: user_answer }
      let(:other_user_answer_attachment) { create :attachment, attachable: other_user_answer }

      context 'destroy' do
        context 'question attachment' do
          it { is_expected.to be_able_to :destroy, user_question_attachment, user: user }
          it { is_expected.to_not be_able_to :destroy, other_user_question_attachment, user: other_user }
        end

        context 'answer attachment' do
          it { is_expected.to be_able_to :destroy, user_answer_attachment, user: user }
          it { is_expected.to_not be_able_to :destroy, other_user_answer_attachment, user: other_user }
        end
      end
    end
    
    context 'Comment' do
      let(:question) { create :question}
      let(:answer) { create :answer}
      let(:comment_to_question) { create :comment, commentable: question, user: user}
      let(:comment_to_answer) { create :comment, commentable: answer, user: user}
      context 'create' do
        it { is_expected.to be_able_to :create, comment_to_question }
        it { is_expected.to be_able_to :create, comment_to_answer }
      end
    end

    context 'Subscriptions' do
      let(:question) { create :question}
      let(:user_subscription) { create :subscription, question: question, user: user }
      let(:other_user_subscription) { create :subscription, question: question, user: other_user }

      context 'create' do
        it { should be_able_to :create, Subscription }
      end

      context 'destroy' do
        it { should be_able_to :destroy, user_subscription }
        it { should_not be_able_to :destroy, other_user_subscription }
      end
    end
  end
end
