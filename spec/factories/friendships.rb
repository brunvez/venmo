FactoryBot.define do
  factory :friendship do
    association :first_user, factory: :user
    association :second_user, factory: :user
  end
end
