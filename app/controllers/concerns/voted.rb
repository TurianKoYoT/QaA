module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote, :destroy_vote]
    respond_to :json, only: [:vote]
  end

  def vote
    authorize! :vote, @votable
    @vote = current_user.votes.create(value: params[:value], votable: @votable)
    respond_with({vote: @vote, votable: @votable}, location: @votable)
  end

  def destroy_vote
    authorize! :destroy_vote, @votable
    @vote = @votable.votes.where(user: current_user).first

    @vote.destroy
    respond_with @vote do |format|
      format.json { render json: { vote: @vote, votable: @votable.reload} }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end
end
