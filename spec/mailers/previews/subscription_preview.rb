# Preview all emails at http://localhost:3000/rails/mailers/subscription
class SubscriptionPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription/question
  def question
    SubscriptionMailer.question
  end

end
