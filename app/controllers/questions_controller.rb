class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [ :show, :update, :destroy ]
  
  after_action :publish_question, only: [:create]
  
  include Voted
  
  def index
    @questions = Question.all
  end
  
  def show
    @answers = @question.answers.all
    @answer = @question.answers.new
    @answer.attachments.build
  end
  
  def new
    @question = Question.new
    @question.attachments.build
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

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/questions',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_delete])
  end
end
