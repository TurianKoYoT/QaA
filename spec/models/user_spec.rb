require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  
  describe "author_of" do
    let(:user) { create :user }
    let(:wrong_user) { create :user }
    let(:object) { Struct.new(:user_id) }

    it "return true for user object" do
      user_object = object.new(user.id)
      expect(user).to be_author_of user_object
    end

    it "returns false for other user object" do
      other_object = object.new(wrong_user.id)
      expect(user).to_not be_author_of other_object
    end
  end
end
