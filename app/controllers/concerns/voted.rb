module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote, :destroy_vote]
  end

  def vote
    if current_user.author_of?(@votable) || current_user.voted_for(@votable)
      return render(json: { message: 'error' }, status: :forbidden)
    end

    @vote = current_user.votes.new(value: params[:value], votable: @votable)
    if @vote.save
      render json: { votable: @votable, vote: @vote }
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy_vote
    @vote = @votable.votes.where(user: current_user).first

    return render(json: { message: 'error' }, status: :forbidden) unless @vote

    if @vote.destroy
      render json: { votable: @votable.reload, vote: @vote }
    else
      render json: @votable.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
