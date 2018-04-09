require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '#find' do
    let(:location) { 'Questions' }
    let(:everywhere) { 'Everywhere' }
    let(:invalid_location) { 'Subscription' }
    let(:query) { 'query' }

    context 'with invalid location' do
      it 'does not make search' do
        expect(invalid_location.classify.constantize).to_not receive(:search).with(query)
        Search.find(query, invalid_location)
      end
    end

    context 'everywhere' do
      it 'calls global search' do
        expect(ThinkingSphinx).to receive(:search).with(query)
        Search.find(query, everywhere)
      end
    end

    context 'with valid location' do
      it 'calls search on location' do
        Search::LOCATION.each do |location|
          next if location == 'Everywhere'
          expect(location.classify.constantize).to receive(:search).with(query)
          Search.find(query, location)
        end
      end
    end
  end
end
