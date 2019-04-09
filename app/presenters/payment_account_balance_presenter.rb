class PaymentAccountBalancePresenter
  SIGNIFICANT_FIGURES = 2
  def initialize(payment_account)
    @payment_account = payment_account
  end

  def balance
    @payment_account.balance.round(2)
  end
end
