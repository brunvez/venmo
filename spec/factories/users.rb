FactoryBot.define do
  factory :user do
    name 'John Doe'
    sequence(:username) { |n| "user#{n}"}
  end
end
