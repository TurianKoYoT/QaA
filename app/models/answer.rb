class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable, inverse_of: :attachable

  scope :ordered, -> { order(created_at: :asc) }
  scope :with_best_answer, -> { order(best: :desc).ordered }
  
  validates :body, presence: true, length: { maximum: 2000 }
  
  after_create :notify_subscribers
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def choose_best
    ActiveRecord::Base.transaction do
      self.update!(best: true)
      self.question.answers.where.not(id: self.id).update_all(best: false)
    end
  end

  private

  def notify_subscribers
    QuestionNotifierJob.perform_later(self)
  end
end
