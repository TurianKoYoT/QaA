require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:location) { 'Questions' }
    let(:query) { 'query' }

    subject { get :index, params: {query: query, location: location} }

    it 'renders index view' do
      subject
      expect(response).to render_template :index
    end

    it 'assigns @query' do
      subject
      expect(assigns(:query)).to eq query
    end

    it 'assigns @location' do
      subject
      expect(assigns(:location)).to eq location
    end

    it 'calls Search with params' do
      expect(Search).to receive(:find).with(query, location)
      subject
    end
  end
end
