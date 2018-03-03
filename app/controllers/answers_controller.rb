class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create ]
  before_action :load_answer, only: [ :destroy ]
  
  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user) )
    if @answer.save
      redirect_to @question, notice: t('.successfull')
    else
      render "questions/show"
    end
  end
  
  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question_id), notice: t('.successfull')
    else
      redirect_to question_path(@answer.question_id)
    end
  end
  
  private
  
  def load_answer
    @answer = Answer.find(params[:id])
  end
  
  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end
end
