class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  after_action :create_comment, only: [:create]

  respond_to :js

  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end
  
  private
  
  def load_commentable
    commentable_id = params[:comment][:commentable_id]
    commentable_type = params[:comment][:commentable_type].classify.constantize
    @commentable = commentable_type.find(commentable_id)
    if commentable_type != Question
      @question = @commentable.question
    end
  end
  
  def create_comment
    if @commentable.class != Question
      @question = @commentable.question
    else
      @question = @commentable
    end
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments_for_question-#{@question.id}",
      comment: @comment,
    )
  end
  
  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end
end
