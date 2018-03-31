require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let(:question) { create :question }

    context 'unauthorised' do
      let(:path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :get }
      it_behaves_like 'unauthorised'
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:answers) { create_list :answer, 2 }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token}, as: :json }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers to question' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body rating best question_id user_id created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }

    context 'unauthorsied' do
      let(:path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }
      it_behaves_like 'unauthorised'
    end

    context 'autirized' do
      let(:access_token) { create :access_token }
      let!(:attachment) { create :attachment, attachable: answer }
      let!(:comment) { create :comment, commentable: answer }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token}, as: :json }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body rating best question_id user_id created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
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

  describe 'POST /answers' do
    let(:question) { create :question}

    context 'unauthorsied' do
      let(:path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }
      it_behaves_like 'unauthorised'
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:answer) { attributes_for :answer }
      let(:invalid_answer) { attributes_for :invalid_answer }

      context 'with valid params' do
        let(:path) { "/api/v1/questions/#{question.id}/answers" }
        let(:params) { {answer: answer, access_token: access_token.token} }

        it 'resonse with 201 status' do
          post path, params: params, as: :json
          expect(response).to have_http_status :created
        end

        it 'creates new new answer to question' do
          expect { post path, params: params, as: :json }.to change(question.answers, :count).by(1)
        end

        it 'returns new answer' do
          post path, params: params, as: :json
          expect(response.body).to be_json_eql(answer[:body].to_json).at_path('body')
        end
      end

      context 'with invalid params' do
        let(:path) { "/api/v1/questions/#{question.id}/answers" }
        let(:params) { {answer: invalid_answer, access_token: access_token.token} }

        it 'response with 422 status' do
          post path, params: params, as: :json
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns errors' do
          post path, params: params, as: :json
          expect(response.body).to have_json_path('errors')
        end

        it "don't create new answer" do
          expect { post path, params: params, as: :json }.not_to change(Answer, :count)
        end
      end
    end
  end
end
