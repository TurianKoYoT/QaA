require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  
  describe "#author_of" do
    let(:user) { create :user }
    let(:wrong_user) { create :user }
    let(:object) { Struct.new(:user_id) }

    it "return true for user object" do
      user_object = object.new(user.id)
      expect(user).to be_author_of user_object
    end

    it "returns false for other user object" do
      other_object = object.new(wrong_user.id)
      expect(user).to_not be_author_of other_object
    end
  end
  
  describe ".find_for_oauth" do
    let!(:user) { create :user }

    context 'user has authorization already' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end
    
    context 'user does not have authorization' do
      context 'user already exists' do
        let!(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end
        
        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end
        
        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
        
        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
      
      context 'user does not exists' do
        let!(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: 'new@user.com' }) }
        
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
    
    context "provider don't return email and user add it manually" do
      let(:user) { attributes_for :user }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678', unconfirm: 'true', info: { email: user[:email]} ) }
      it 'create new user' do
        expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'fiills in email from params' do
        expect(User.find_for_oauth(auth).email).to eq user[:email]
      end

      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).not_to be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.uid).to eq auth.uid
        expect(authorization.provider).to eq auth.provider
      end

      it 'returns unconfirmed user' do
        expect(User.find_for_oauth(auth)).not_to be_confirmed
      end
    end
  end
end
