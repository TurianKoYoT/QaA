class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  scope :ordered, -> { order(created_at: :asc) }
  
  validates :body, presence: true, length: { maximum: 2000 }
  

end
