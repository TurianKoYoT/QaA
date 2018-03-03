class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true, length: { maximum: 2000 }
end
