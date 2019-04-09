class PaymentFeedPresenter
  PAYMENT_DATE_FORMAT = '%B %d, %Y'
  SIGNIFICANT_FIGURES = 2

  delegate :id, :description, to: :@payment

  def initialize(payment)
    @payment = payment
  end

  def title
    I18n.t('api.presenters.payment_feed.title',
           sender:   sender_name,
           receiver: receiver_name,
           date:     payment_date)
  end

  def amount
    @payment.amount.round(2)
  end

  private

  def sender_name
    @payment.sender.name
  end

  def receiver_name
    @payment.receiver.name
  end

  def payment_date
    @payment.created_at.strftime(PAYMENT_DATE_FORMAT)
  end
end
