shared_examples 'Votable' do
  it { should have_many(:votes).dependent(:destroy) }
end
