FactoryBot.define do
  factory :payment do
    association :sender, factory: :user
    association :receiver, factory: :user
    amount 50
  end
end
