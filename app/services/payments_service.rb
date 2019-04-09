class PaymentsService
  class << self
    def payments_for_user(user, max, offset)
      user
        .sent_payments
        .or(user.received_payments)
        .limit(max)
        .offset(offset)
    end

    def create(user_id, friend_id:, amount:, description:)
      user   = User.find(user_id)
      friend = user.friends.find(friend_id)
      ActiveRecord::Base.transaction do
        withdraw_money_from_user(user, amount)
        add_money_to_user(friend, amount)
        register_payment(user, friend, amount, description)
      end
    end

    private

    def withdraw_money_from_user(user, amount)
      account = user.payment_account
      transfer_money_to_account(account, amount) if amount > account.balance
      account.subtract_from_balance!(amount)
    end

    def transfer_money_to_account(account, amount)
      transfer_amount = amount - account.balance
      MoneyTransferService.transfer!(account, transfer_amount)
    end

    def add_money_to_user(user, amount)
      user.payment_account.add_to_balance!(amount)
    end

    def register_payment(sender, receiver, amount, description)
      Payment.create!(sender:      sender,
                      receiver:    receiver,
                      amount:      amount,
                      description: description)
    end
  end
end
