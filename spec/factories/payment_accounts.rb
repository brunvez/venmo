FactoryBot.define do
  factory :payment_account do
    association :user
    balance 300
  end
end
