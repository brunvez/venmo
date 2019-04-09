module Api::V1
  class FeedsController < ApplicationController
    PAYMENTS_PER_PAGE = 10

    def show
      current_user = User.find(params[:user_id])
      offset       = (current_page - 1) * PAYMENTS_PER_PAGE
      payments     = PaymentsService.payments_for_user(current_user,
                                                       PAYMENTS_PER_PAGE,
                                                       offset)
      @payments    = payments.ordered_by_date.map do |payment|
        PaymentFeedPresenter.new(payment)
      end
    end

    private

    def current_page
      params[:page].try(:to_i) || 1
    end
  end
end
