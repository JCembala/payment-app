# Payment-app

In one terminal
stripe listen --forward-to localhost:3000/webhooks/stripe

In another terminal
docker compose exec web bundle exec rails db:create db:migrate db:seed

localhost:3000
localhost:1080 - mailcatcher

docker compose exec web bundle exec rspec
