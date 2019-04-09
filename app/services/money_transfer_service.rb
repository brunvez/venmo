class MoneyTransferService
  class << self
    def transfer!(account, amount)
      withdraw_money_from_source(account.try(:payment_source))
      account.add_to_balance!(amount)
    end

    private

    def withdraw_money_from_source(_payment_source)
      true
    end
  end
end
