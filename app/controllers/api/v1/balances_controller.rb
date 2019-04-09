module Api::V1
  class BalancesController < ApplicationController
    PAYMENTS_PER_PAGE = 10

    def show
      current_user = User.find(params[:user_id])
      @account     = PaymentAccountBalancePresenter.new(current_user.payment_account)
    end
  end
end
