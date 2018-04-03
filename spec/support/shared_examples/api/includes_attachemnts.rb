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
