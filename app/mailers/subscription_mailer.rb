class SubscriptionMailer < ApplicationMailer
  def question(user, answer)
    @answer = answer
    @question = @answer.question
    mail to: user.email
  end
end
