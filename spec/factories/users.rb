FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example_#{n}@email.com"}
  end
end
