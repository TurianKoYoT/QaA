class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    callback_for(:vkontakte)
  end
  
  def twitter
    callback_for(:twitter)
  end
  
  def update_user
    omniauth_data = session['omniauth_data']
    omniauth_data['info'] = OmniAuth::AuthHash.new(auth_params)
    omniauth_data['unconfirm'] = 'true'
    callback_for(omniauth_data['provider'])
  end
  
  private
  
  def callback_for(provider)
    session['omniauth_data'] ||= request.env['omniauth.auth']
    omniauth_data = session['omniauth_data']

    @user = User.find_for_oauth(omniauth_data)
    if @user&.persisted? && @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
    end
    
    if @user
      render 'devise/confirmations/new' unless @user.confirmed?
    else
      render 'users/update_user'
    end
  end
  
  def auth_params
    params.require(:auth).permit(:email)
  end
end
