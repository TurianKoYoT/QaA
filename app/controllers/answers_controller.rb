class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create, :update ]
  before_action :load_answer, only: [ :destroy, :update, :choose_best ]
  
  after_action :publish_answer, only: [:create]

  include Voted
  
  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user) )
  end
  
  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end
  
  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end
  
  def choose_best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.choose_best
    end
  end
  
  private
  
  def load_answer
    @answer = Answer.find(params[:id])
  end
  
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map(&:attributes)
    
    ActionCable.server.broadcast(
      "answers_for_question-#{@answer.question_id}",
      answer: @answer,
      attachments: attachments,
      question: @answer.question
    )
  end
  
  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_delete])
  end
end
