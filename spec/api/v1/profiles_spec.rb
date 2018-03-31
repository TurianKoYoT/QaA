require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', as: :json
        expect(response.status).to eq 401
      end
      
      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234'}, as: :json
        expect(response.status).to eq 401
      end
    end
    
    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      
      before { get '/api/v1/profiles/me', as: :json, params: { access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end
      
      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not  have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #index' do
    context 'unauthoried' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/profiles', as: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token invalid' do
        get '/api/v1/profiles', params: { access_token: '1234'}, as: :json
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) {  create :user }
      let!(:users) { create_list :user, 2}
      let(:access_token) { create :access_token, resource_owner_id: user.id}

      before { get '/api/v1/profiles/', params: { access_token: access_token.token }, as: :json }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains other users attribute #{attr}" do
          users.each_with_index do |user, index|
            expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("#{index}/#{attr}")
          end
        end
      end

      %w(password enctypted_password).each do |attr|
        it "does not contain other users #{attr}" do
          users.each_with_index do |user, index|
            expect(response.body).not_to have_json_path("#{index}/#{attr}")
          end
        end
      end
    end
  end
end
