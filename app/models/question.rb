class Question < ApplicationRecord
  has_many :answers, -> { with_best_answer }, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable, inverse_of: :attachable
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 48 }
  validates :body, presence: true, length: { maximum: 2000 }
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
