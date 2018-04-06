class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:vkontakte, :twitter]
         
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions
  
  def author_of?(object)
    object.user_id == id
  end

  def voted_for(votable)
    !!votable.votes.find_by(user_id: id)
  end
  
  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth['provider'], uid: auth['uid'].to_s).first
    return authorization.user if authorization
    
    email = auth['info']['email']
    user = User.where(email: email).first
    
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      return nil unless user.save
    end

    user.skip_confirmation! unless auth['unconfirm']
    user.authorizations.create!(provider: auth['provider'], uid: auth['uid'])
    user
  end

  def subscribed?(question)
    subscriptions.where(question_id: question.id).exists?
  end

  def subscription_to(question)
    subscriptions.where(question_id: question.id).first
  end
end
