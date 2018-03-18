require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  
  it { should validate_inclusion_of(:value).in_array([-1,1]) }
  
  context 'votable rating' do
    let(:question) { create(:question) }
    
    it 'increase rating of when created' do
      expect{ create(:vote, votable: question) }.to change{ question.rating }.by(1)
    end
    
    it 'decrease rating of when destroy' do
      vote = create(:vote, votable: question)
      expect{ vote.destroy }.to change{ question.rating }.by(-1)
    end
  end
end
