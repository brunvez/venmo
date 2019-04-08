require 'rails_helper'

describe Friendship, type: :model do
  describe 'validations' do
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }
    
    subject { build(:friendship, first_user: first_user, second_user: second_user) }
    
    it { is_expected.to belong_to(:first_user).class_name(User.to_s) }
    it { is_expected.to belong_to(:second_user).class_name(User.to_s) }
    
    
    context 'when befriending oneself' do
      let(:second_user) { first_user }
      
      it { is_expected.not_to be_valid }

      it 'has a cannot befriend yourself error message' do
        subject.validate
        expect(subject.errors[:base].first).to match(/cannot befriend yourself/)
      end
    end

    context 'when the users are already friends' do
      
      context 'in the same order' do
        before do
          create(:friendship, first_user: first_user, second_user: second_user)
        end
      
        it { is_expected.not_to be_valid }

        it 'has an already friends error message' do
          subject.validate
          expect(subject.errors[:base].first).to match(/already friends/)
        end
      end

      context 'in another order' do
        before do
          create(:friendship, first_user: second_user, second_user: first_user)
        end

        it { is_expected.not_to be_valid }
        
        it 'has an already friends error message' do
          subject.validate
          expect(subject.errors[:base].first).to match(/already friends/)
        end
      end
    end
  end
end
