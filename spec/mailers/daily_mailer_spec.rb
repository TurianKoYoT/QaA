require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 2, created_at: 1.day.ago) }
    let(:mail) { DailyMailer.digest(user) }

    it 'renders receiver email' do
      expect(mail.to).to include(user.email)
    end

    it 'renders sender email' do
      expect(mail.from).to eq (['from@example.com'])
    end

    it 'includes links to questions' do
      questions.each do |question|
        expect(mail.body.encoded).to have_link(question.title, href: question_url(question))
      end
    end
  end
end
