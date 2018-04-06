require 'rails_helper'

RSpec.describe QuestionNotifierJob, type: :job do
  let!(:unsubscribed) { create(:user) }
  let!(:author) { create(:user) }
  let!(:subscribed) { create(:user) }
  let(:question) { create(:question, user: author) }
  let!(:subscription) { create(:subscription, question: question, user: author) }
  let!(:subscription) { create(:subscription, question: question, user: subscribed) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notifications about new answer to subscribed users' do
    expect(SubscriptionMailer).to receive(:question).with(author, answer).and_call_original
    expect(SubscriptionMailer).to receive(:question).with(subscribed, answer).and_call_original
    QuestionNotifierJob.perform_now(answer)
  end

  it 'does not send notifications about answer to unsubscribed user' do
    expect(SubscriptionMailer).to_not receive(:question).with(unsubscribed, answer).and_call_original
    QuestionNotifierJob.perform_now(answer)
  end
end
