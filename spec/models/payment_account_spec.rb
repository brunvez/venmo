require 'rails_helper'

describe PaymentAccount, type: :model do
  describe 'validations' do
    subject { build(:payment_account) }
    
    it { is_expected.to belong_to(:user) }
    
    it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  end
end
