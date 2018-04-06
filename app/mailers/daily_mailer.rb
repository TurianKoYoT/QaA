class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day)

    mail to: user.email
  end
end
