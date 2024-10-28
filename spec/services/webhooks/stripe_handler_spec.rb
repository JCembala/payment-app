require "rails_helper"

RSpec.describe Webhooks::StripeHandler do
  describe ".call" do
    context "when the request is valid" do
      it "returns Response object" do
        event = {
          "type" => "some.event",
          "data" => {
            "object" => {
              "id" => "cs_test",
            },
          },
        }

        request =
          instance_double(
            "ActionDispatch::Request",
            body: StringIO.new(event.to_json),
            env: { "HTTP_STRIPE_SIGNATURE" => "sig" }
          )

        allow(Stripe::Webhook).to receive(:construct_event).and_return(event)

        response = Webhooks::StripeHandler.call(request: request)

        expect(response.status).to eq(200)
        expect(response.message).to eq("Successfully processed event")
      end

      context "when the event type is checkout.session.completed" do
        it "updates the order status to paid" do
          order = create(:order, stripe_session_id: "cs_test")

          event = {
            "type" => "checkout.session.completed",
            "data" => {
              "object" => {
                "id" => "cs_test",
              },
            },
          }

          request =
            instance_double(
              "ActionDispatch::Request",
              body: StringIO.new(event.to_json),
              env: { "HTTP_STRIPE_SIGNATURE" => "sig" }
            )

          allow(Stripe::Webhook).to receive(:construct_event).and_return(event)

          Webhooks::StripeHandler.call(request: request)

          order.reload

          expect(order.status).to eq("paid")
        end

        it "sends an email" do
          create(:order, stripe_session_id: "cs_test")

          event = {
            "type" => "checkout.session.completed",
            "data" => {
              "object" => {
                "id" => "cs_test",
              },
            },
          }

          request =
            instance_double(
              "ActionDispatch::Request",
              body: StringIO.new(event.to_json),
              env: { "HTTP_STRIPE_SIGNATURE" => "sig" }
            )

          allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
          allow(OrderMailer).to receive(:checkout_complete).and_call_original

          expect { Webhooks::StripeHandler.call(request: request) }
            .to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(OrderMailer).to have_received(:checkout_complete)
        end
      end

      context "when the event type is checkout.session.expired" do
        it "updates the order status to failed" do
          order = create(:order, stripe_session_id: "cs_test")

          event = {
            "type" => "checkout.session.expired",
            "data" => {
              "object" => {
                "id" => "cs_test",
              },
            },
          }

          request =
            instance_double(
              "ActionDispatch::Request",
              body: StringIO.new(event.to_json),
              env: { "HTTP_STRIPE_SIGNATURE" => "sig" }
            )

          allow(Stripe::Webhook).to receive(:construct_event).and_return(event)

          Webhooks::StripeHandler.call(request: request)

          order.reload

          expect(order.status).to eq("failed")
        end

        it "sends an email" do
          create(:order, stripe_session_id: "cs_test")

          event = {
            "type" => "checkout.session.expired",
            "data" => {
              "object" => {
                "id" => "cs_test",
              },
            },
          }

          request =
            instance_double(
              "ActionDispatch::Request",
              body: StringIO.new(event.to_json),
              env: { "HTTP_STRIPE_SIGNATURE" => "sig" }
            )

          allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
          allow(OrderMailer).to receive(:checkout_expired).and_call_original

          expect { Webhooks::StripeHandler.call(request: request) }
            .to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(OrderMailer).to have_received(:checkout_expired)
        end
      end
    end

    context "when the request is invalid" do
      context "when JSON::ParserError is raised" do
        it "returns Response object" do
          request =
            instance_double(
              "ActionDispatch::Request",
              body: StringIO.new("invalid json"),
              env: { "HTTP_STRIPE_SIGNATURE" => "sig" }
            )

          allow(Stripe::Webhook)
            .to receive(:construct_event)
            .and_raise(JSON::ParserError.new("unexpected token at 'invalid json'"))

          response = Webhooks::StripeHandler.call(request: request)

          expect(response.status).to eq(422)
          expect(response.message).to eq("unexpected token at 'invalid json'")
        end
      end

      context "when Stripe::SignatureVerificationError is raised" do
        it "returns Response object" do
          request =
            instance_double(
              "ActionDispatch::Request",
              body: StringIO.new("body"),
              env: { "HTTP_STRIPE_SIGNATURE" => "sig" }
            )

          allow(Stripe::Webhook)
            .to receive(:construct_event)
            .and_raise(
              Stripe::SignatureVerificationError.new(
                "Signature verification failed",
                "sig"
              )
            )

          response = Webhooks::StripeHandler.call(request: request)

          expect(response.status).to eq(401)
          expect(response.message).to eq("Signature verification failed")
        end
      end
    end
  end
end
