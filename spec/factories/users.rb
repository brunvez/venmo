FactoryBot.define do
  factory :user do
    name 'John Doe'
    sequence(:username) { |n| "user#{n}" }

    transient do
      account_balance { 100 }
    end

    after(:create) do |user, evaluator|
      create(:payment_account, user: user, balance: evaluator.account_balance)
    end
  end
end
