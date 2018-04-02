require 'rails_helper'

describe 'Question API' do
  describe 'GET /index' do
    context 'unauthorsied' do
      let(:path) { '/api/v1/questions' }
      let(:method) { :get }
      it_behaves_like 'unauthorised'
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_list :question, 2 }
      let(:question) { questions.first }

      before { get '/api/v1/questions', params: { access_token: access_token.token}, as: :json }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body rating user_id created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create :question }
    context 'unauthorsied' do
      let(:path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :get }
      it_behaves_like 'unauthorised'
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:answer) { create :answer, question: question }
      let!(:attachment) { create :attachment, attachable: question }
      let!(:comment) { create :comment, commentable: question }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token}, as: :json }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body rating user_id created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end
      context 'comments' do
        it_behaves_like 'includes comments'
      end

      context 'attachments' do
        it_behaves_like 'includes attachments'
      end
    end
  end

  describe 'POST /questions' do
    context 'unauthorsied' do
      let(:path) { '/api/v1/questions' }
      let(:method) { :post }
      it_behaves_like 'unauthorised'
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:question) { attributes_for :question }
      let(:invalid_question) { attributes_for :invalid_question }

      context 'with valid params' do
        it 'resonse with 201 status' do
          post '/api/v1/questions', params: {question: question, access_token: access_token.token}, as: :json
          expect(response).to have_http_status :created
        end

        it 'creates new question' do
          expect { post '/api/v1/questions', params: {question: question, access_token: access_token.token}, as: :json }.to change(Question, :count).by(1)
        end

        it 'returns new question' do
          post '/api/v1/questions', params: {question: question, access_token: access_token.token}, as: :json
          expect(response.body).to be_json_eql(question[:title].to_json).at_path('title')
          expect(response.body).to be_json_eql(question[:body].to_json).at_path('body')
        end
      end

      context 'with invalid params' do
        it 'response with 422 status' do
          post '/api/v1/questions', params: {question: invalid_question, access_token: access_token.token}, as: :json
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns errors' do
          post '/api/v1/questions', params: {question: invalid_question, access_token: access_token.token}, as: :json
          expect(response.body).to have_json_path('errors')
        end

        it "don't create new question" do
          expect { post '/api/v1/questions', params: {question: invalid_question, access_token: access_token.token}, as: :json }.not_to change(Question, :count)
        end
      end
    end
  end
end
