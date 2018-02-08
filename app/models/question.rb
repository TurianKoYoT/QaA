class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 48 }
  validates :body, presence: true, length: { maximum: 2000 }
end
