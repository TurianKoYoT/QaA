class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [ :show, :update, :destroy ]
  
  def index
    @questions = Question.all
  end
  
  def show
    @answers = @question.answers.all
    @answer = @question.answers.new
  end
  
  def new
    @question = Question.new
  end
  
  def create
    @question = Question.create(question_params.merge(user: current_user))
    if @question.save
      redirect_to @question, notice: t('.successfull')
    else
      render :new
    end
  end
  
  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end
  
  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: t('.successfull')
    else
      redirect_to @question
    end
  end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
