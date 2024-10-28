FactoryBot.define do
  factory :order do
    status { "pending" }
    stripe_session_id { "session_id" }
    association :user
    association :package
  end
end
