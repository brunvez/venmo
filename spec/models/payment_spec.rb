require 'rails_helper'

describe Payment, type: :model do
  describe 'validations' do
    subject { build(:payment) }

    it { is_expected.to belong_to(:receiver).class_name(User.to_s) }
    it { is_expected.to belong_to(:sender).class_name(User.to_s) }

    it { is_expected.to validate_inclusion_of(:amount).in_range(0..1000) }

    context 'when the sender is the same as the receiver' do
      let(:sender) { create(:user) }

      subject { build(:payment, sender: sender, receiver: sender) }

      it { is_expected.not_to be_valid }

      it 'has a cannot send payment to yourself error' do
        subject.validate
        expect(subject.errors[:base].first).to match(/cannot send a payment to yourself/)
      end
    end
  end
end
