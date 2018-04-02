shared_examples 'unauthorised' do
  it 'returns 401 status if there is no access token' do
    send(method, path, {as: :json})
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access token invalid' do
    send(method, path, {params: { access_token: '12345'}, as: :json})
    expect(response.status).to eq 401
  end
end

shared_examples 'includes comments' do
  it 'included in answer object' do
    expect(response.body).to have_json_size(1).at_path("comments")
  end

  %w(body commentable_type commentable_id user_id created_at updated_at).each do |attr|
    it "contains #{attr}" do
      expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
    end
  end
end

shared_examples 'includes attachments' do
  it 'included in answer object' do
    expect(response.body).to have_json_size(1).at_path("attachments")
  end

  %w(file attachable_id attachable_type created_at updated_at).each do |attr|
    it "contains #{attr}" do
      expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
    end
  end
end
