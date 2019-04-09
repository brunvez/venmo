module Api::V1
  class PaymentsController < ApplicationController
    def create
      PaymentsService.create(params[:user_id], **payment_params)
      head 200
    end

    private

    def payment_params
      params.require(:payment)
        .permit(:friend_id, :amount, :description)
        .to_hash
        .symbolize_keys
    end
  end
end
