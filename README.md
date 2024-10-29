# Payment-app

## Installation

### Prerequisites
#### Docker
In order to run the APP you need to have Docker and Docker Compose installed. <br>
The best way is to instal Docker Desktop. You can download it from [here](https://www.docker.com/products/docker-desktop/). <br>

#### Stripe CLI
You need to have the Stripe CLI installed in order to test webhooks. Instalation guide is [here](https://docs.stripe.com/stripe-cli). <br>

### Environment variables
After cloning the repository, run the following command:
```bash
cp .env.example .env
```
Then, you need to set the `STRIPE_SECRET_KEY` in the `.env` file with your Stripe API key. <br>

You need also to set the `STRIPE_WEBHOOK_SECRET` with the webhook secret that you will get from the Stripe CLI. <br>
It will be printed when you run Stripe to listen for events - look at the section [Webhooks](#webhooks). <br>

### Building and running the API
After cloning repository, you can run the following command to build and start the API:
```bash
docker compose up --build
```

Then you can access the APP at
- [localhost:3000](http://localhost:3000)
- [localhost:1080](http://localhost:1080) - mailcatcher (you can see the emails that are sent by the APP)


### Creating the database
Next, you need to create the database, run the migrations and seed the database:
```bash
docker compose exec web bundle exec rails db:create db:migrate db:seed
```

### How to run the test suite
```bash
docker compose exec web bundle exec rspec
```

### Webhooks
In order to be able to fully use the APP, you need to start the Stripe CLI:
```bash
stripe listen --forward-to localhost:3000/webhooks/stripe
```
This command should print your webhook secret like so: `Your webhook signing secret is whsec_...`. <br>
You need to keep this terminal open in order to receive the events from Stripe.

Now you can test the APP by going to [localhost:3000](http://localhost:3000) and creating a new payment. <br>
You can see the events in the terminal where you started the Stripe CLI. <br>
We listen for the `checkout.session.completed` and `checkout.session.expired` events in order to update the payment status. <br>
Those events were chosen because we are using the Stripe Checkout which can be visited until it's expired. <br>
If the session is completed, the payment is successful, if it's expired, the payment is failed. <br>
