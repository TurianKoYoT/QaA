class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, -> { with_best_answer }, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable, inverse_of: :attachable
  has_many :subscriptions, dependent: :destroy
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 48 }
  validates :body, presence: true, length: { maximum: 2000 }

  after_create :subscribe_author

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  private

  def subscribe_author
    subscriptions.create(user: user)
  end
end
