class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  respond_to :js

  def destroy
    @attachment = Attachment.find(params[:id])
    return unless current_user.author_of?(@attachment.attachable)
    respond_with(@attachment.destroy)
  end
end
