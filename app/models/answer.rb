class Answer < ApplicationRecord
  belongs_to :question
  
  validates :body, presence: true, length: { maximum: 2000 }
end
