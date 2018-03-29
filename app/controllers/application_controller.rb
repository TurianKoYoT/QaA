require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/javascript', status: :forbidden }
      format.json { render json: exception, status: :forbidden }
    end
  end
  
  before_action :gon_user, unless: :devise_controller?
  
  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
