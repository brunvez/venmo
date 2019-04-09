require 'rails_helper'

describe PaymentsService do
  describe '.payments_for_user' do
    let(:user) { create(:user) }
    let(:max) { 10 }
    let(:offset) { 0 }
    let!(:other_payment) { create(:payment) }

    subject { PaymentsService.payments_for_user(user, max, offset) }

    context 'when the user received or sent payments' do
      let!(:payments) { create_list(:payment, 2, sender: user) + create_list(:payment, 2, receiver: user) }

      context 'when the max is bigger than the number of payments' do

        it 'returns only the users payments' do
          expect(subject).to match_array(payments)
        end
      end

      context 'when the max is less than the number of payments' do
        let(:max) { 3 }

        it 'returns only that number of payments' do
          expect(subject).to match_array(payments.first(3))
        end
      end

      context 'when the offset is not 0' do
        let(:offset) { 2 }

        it 'returns the payments with an offset' do
          expect(subject).to match_array(payments.last(2))
        end
      end
    end

    context 'when the user did not received or send payments' do

      it { is_expected.to be_empty }
    end
  end

  describe '.create' do
    let(:user_account_balance) { 700 }
    let!(:user) { create(:user, account_balance: user_account_balance) }
    let!(:friend) { create(:user) }
    let(:user_id) { user.id }
    let(:friend_id) { friend.id }
    let(:amount) { 300 }
    let(:description) { 'Dinner' }

    subject { PaymentsService.create(user_id,
                                     friend_id:   friend_id,
                                     amount:      amount,
                                     description: description) }

    context 'when the users are friends' do

      before do
        create(:friendship, first_user: user, second_user: friend)
      end

      context 'when the users exist and the parameters are valid' do
        context 'when the sender has enough money on its account' do
          it 'creates a payment' do
            expect { subject }.to change(Payment, :count).by(1)
          end

          it 'increases the balance of the friend account' do
            expect { subject }.to change { friend.payment_account.reload.balance }.by(amount)
          end

          it 'decreases the balance of the user account' do
            expect { subject }.to change { user.payment_account.reload.balance }.by(-1 * amount)
          end
        end

        context 'when the sender does not have enough money on its account' do
          let(:user_account_balance) { 100 }

          it 'transfers money from their bank account' do
            expect(MoneyTransferService).to receive(:transfer!)
            subject
          end

          it 'creates a payment' do
            expect { subject }.to change(Payment, :count).by(1)
          end

          it 'increases the balance of the friend account' do
            expect { subject }.to change { friend.payment_account.reload.balance }.by(amount)
          end

          it 'decreases the balance of the user account' do
            expect { subject }.to change { user.payment_account.reload.balance }.by(-1 * user_account_balance)
          end
        end

        context 'when the sender does not have any money on its account' do
          let(:user_account_balance) { 0 }

          it 'transfers money from their bank account' do
            expect(MoneyTransferService).to receive(:transfer!)
            subject
          end

          it 'creates a payment' do
            expect { subject }.to change(Payment, :count).by(1)
          end

          it 'increases the balance of the friend account' do
            expect { subject }.to change { friend.payment_account.reload.balance }.by(amount)
          end

          it 'leaves the user account balance in 0' do
            expect { subject }.not_to change { user.payment_account.reload.balance }
          end
        end
      end

      context 'when the sender does not exist' do
        let(:user_id) { 0 }

        it 'raises an exception' do
          expect { subject }.to raise_exception(ActiveRecord::RecordNotFound)
        end
      end

      context 'when the receiver does not exist' do
        let(:friend_id) { 0 }

        it 'raises an exception' do
          expect { subject }.to raise_exception(ActiveRecord::RecordNotFound)
        end
      end

      context 'when the amount is invalid' do
        let(:amount) { 1001 }

        it 'raises an exception' do
          expect { subject }.to raise_exception(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'when the users are not friends' do
      it 'raises an exception' do
        expect { subject }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
