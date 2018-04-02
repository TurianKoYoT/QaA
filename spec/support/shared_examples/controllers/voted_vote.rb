shared_examples 'POST voted#vote' do
  let(:other_user) { create(:other_user) }
  let(:vote) { attributes_for(:vote) }

  context 'not author of votable' do
    before { sign_in(other_user) }

    context 'with valid params' do
      subject(:post_vote) { post :vote, params: { id: votable, value: vote[:value] }, format: :json }

      it 'change count of votes for votable' do
        expect { post_vote }.to change(votable.votes, :count).by(1)
      end
      
      it 'change count of votes for user' do
        expect { post_vote }.to change(other_user.votes, :count).by(1)
      end

      it 'assigns votable' do
        post_vote
        expect(assigns(:votable)).to eq votable
      end
      
      it 'returns success' do
        post_vote
        expect(response).to have_http_status(:success)
      end
    end
    
    context 'with invalid params' do
      subject(:post_vote) { post :vote, params: { id: votable, value: 2 }, format: :json }
      
      it 'does not change votes' do
        expect { post_vote }.to_not change(Vote, :count)
      end
    end
  end
  
  context 'author of votable' do
    before { sign_in(user) }
    subject(:post_vote) { post :vote, params: { id: votable, value: vote[:value] }, format: :json }
    
    it 'does not change votes' do
      expect { post_vote }.to_not change(Vote, :count)
    end
    
    it 'returns forbidden' do
      post_vote
      expect(response).to have_http_status(:forbidden)
    end
  end
end
