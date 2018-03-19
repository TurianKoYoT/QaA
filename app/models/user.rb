class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :questions
  has_many :answers
  has_many :votes
  
  def author_of?(object)
    object.user_id == id
  end

  def voted_for(votable)
    !!votable.votes.find_by(user_id: id)
  end
end
