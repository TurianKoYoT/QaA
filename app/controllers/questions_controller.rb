class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [ :show, :update, :destroy ]
  before_action :build_answer, only: [ :show ]
  
  after_action :publish_question, only: [:create]
  
  include Voted

  respond_to :js, only: [:update]

  load_and_authorize_resource

  def index
    respond_with(@questions = Question.all)
  end
  
  def show
    @answers = @question.answers.all
    respond_with @question
  end
  
  def new
    respond_with(@question = Question.new)
  end
  
  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end
  
  def update
    @question.update(question_params)
    respond_with @question
  end
  
  def destroy
    flash[:notice] = t('.successfull') if @question.destroy
    respond_with(@question.destroy)
  end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def build_answer
    @answer = @question.answers.build
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
