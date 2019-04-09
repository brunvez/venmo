class Payment < ApplicationRecord
  MAX_AMOUNT = 1000.0

  belongs_to :receiver, class_name: User.to_s
  belongs_to :sender, class_name: User.to_s

  validates :amount, inclusion: {
    in: 0..MAX_AMOUNT,
    message: I18n.t('api.errors.models.payment.amount_not_in_range', min: 0, max: MAX_AMOUNT.to_i)
  }
  validate :no_self_payment

  scope :ordered_by_date, -> { order(created_at: :desc) }
  private

  def no_self_payment
    return unless receiver_id == sender_id
    errors.add(:base, I18n.t('api.errors.models.payment.cannot_send_payment_to_yourself'))
  end
end
