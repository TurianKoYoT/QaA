class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: [-1, 1] }

  after_create :rating_count
  after_destroy :rating_count
  
  private

  def rating_count
    votable.update(rating: votable.votes.sum(:value))
  end
end
