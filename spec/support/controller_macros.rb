module ControllerMacros
  def sign_in_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = create(:user)
      sign_in user
    end
  end
  
  def sign_in_as_wrong_user
    before do
      @user = create(:other_user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end
