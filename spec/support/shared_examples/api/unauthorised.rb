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
