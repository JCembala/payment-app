FactoryBot.define do
  factory :package do
    sequence(:name) { |n| "Package #{n}" }
    price_cents { 10000 }
  end
end
