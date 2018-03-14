class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  scope :ordered, -> { order(created_at: :asc) }
  scope :with_best_answer, -> { order(best: :desc).ordered }
  
  validates :body, presence: true, length: { maximum: 2000 }
  
  def choose_best
    ActiveRecord::Base.transaction do
      self.update!(best: true)
      self.question.answers.where.not(id: self.id).update_all(best: false)
    end
  end
end