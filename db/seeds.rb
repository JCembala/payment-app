User.destroy_all
Package.destroy_all

User.create!(email: "example.user@gmail.com")

Package.create!(name: "Basic", price_cents: 1000)
Package.create!(name: "Pro", price_cents: 2000)
Package.create!(name: "Enterprise", price_cents: 50000)
