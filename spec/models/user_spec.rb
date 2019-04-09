require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_uniqueness_of(:username) }
  end

  describe '#friends' do
    let(:user) { create(:user) }
    
    subject { user.friends }
    
    context 'when the user has no friends' do
      
      it { is_expected.to be_empty }
    end

    context 'when the user has friends' do
      let(:friends) { create_list(:user, 2) }
      
      before do
        friends.each do |friend|
          create(:friendship, first_user: user, second_user: friend)
        end
      end
      
      it { is_expected.to match_array(friends) }
      
      it 'does not include the user' do
        expect(subject).not_to include(user)
      end
    end
  end
end
