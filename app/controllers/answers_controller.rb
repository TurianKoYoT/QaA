class AnswersController < ApplicationController
  before_action :load_question, only: [ :new, :create ]
  
  def show
    @answer = Answer.find(params[:id])
  end
  
  def new
    @answer = @question.answers.new
  end
  
  def create
    @answer = @question.answers.create(answer_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end
  
  private
  
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end
end
