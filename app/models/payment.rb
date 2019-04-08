class Payment < ApplicationRecord
  MAX_AMOUNT = 1000

  belongs_to :receiver, class_name: User.to_s
  belongs_to :sender, class_name: User.to_s

  validates :amount, inclusion: { in: 0..MAX_AMOUNT }
  validate :no_self_payment

  private

  def no_self_payment
    return unless receiver_id == sender_id
    errors.add(:base, I18n.t('api.errors.models.payment.cannot_send_payment_to_yourself'))
  end
end
