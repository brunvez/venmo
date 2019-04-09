class PaymentAccount < ApplicationRecord
  belongs_to :user

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def add_to_balance!(amount)
    increment!(:balance, amount)
  end

  def subtract_from_balance!(amount)
    decrement!(:balance, amount)
  end
end
