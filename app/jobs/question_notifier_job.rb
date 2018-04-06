class QuestionNotifierJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.each do |subscribe|
      SubscriptionMailer.question(subscribe.user, answer)&.deliver_later
    end
  end
end
