class Ability
  include CanCan::Ability
  
  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilites
    end
  end
  
  def guest_abilites
    can :read, :all
  end
  
  def admin_abilities
    can :manage, :all
  end
  
  def user_abilities
    guest_abilites
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    
    can :choose_best, Answer do |answer|
      user.author_of?(answer.question)
    end
    
    can [:vote, :destroy_vote], [Question, Answer] do |votable|
      !user.author_of?(votable) || user.voted_for(votable)
    end
    
    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end
  end
end
