shared_examples 'DELETE voted#destroy_vote' do
  let(:other_user) { create(:other_user) }
  let!(:vote) { create(:vote, votable: votable, user: other_user) }
  subject(:delete_vote) { delete :destroy_vote, params: { id: votable }, format: :json }
  
  context 'author of vote' do
    before { sign_in(other_user) }
    
    it 'change vote count for votable' do
      expect{ delete_vote }.to change(votable.votes, :count).by(-1)
    end
    
    it 'change vote count for user' do
      expect{ delete_vote }.to change(other_user.votes, :count).by(-1)
    end
    
    it 'assigns votable' do
      delete_vote
      expect(assigns(:votable)).to eq votable
    end
    
    it 'returns success' do
      delete_vote
      expect(response).to have_http_status(:success)
    end
  end
  
  context 'not author of vote' do
    before { sign_in(user) }
    
    it 'does not change vote count' do
      expect{ delete_vote }.to_not change(Vote, :count)
    end
    
    it 'returns forbidden' do
      delete_vote
      expect(response).to have_http_status(:forbidden)
    end
  end
end

shared_examples 'voted ability' do
  context 'vote' do
    it { is_expected.to be_able_to :vote, other_user_votable, user: user }
    it { is_expected.not_to be_able_to :vote, user_votable, user: user }
  end

  context 'destroy_vote' do
    it { is_expected.to be_able_to :destroy_vote, other_user_votable, user: user }
    it { is_expected.not_to be_able_to :destroy_vote, user_votable, user: user }
  end
end
