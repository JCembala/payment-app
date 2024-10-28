module Webhooks
  class StripeController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET']
        )
      rescue JSON::ParserError => e
        render json: { error: e.message }, status: 422
        return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: e.message }, status: 401
        return
      end

      case event['type']
      when 'checkout.session.completed'
        handle_checkout_completed(event)
      when 'checkout.session.expired'
        handle_checkout_expired(event)
      end

      render json: { message: 'success' }, status: 200
    end

    private

    def handle_checkout_completed(event)
      session = event['data']['object']
      order = Order.find_by(stripe_session_id: session.id)

      return if order.nil?

      order.update(status: :paid)
    end

    def handle_checkout_expired(event)
      session = event['data']['object']
      order = Order.find_by(stripe_session_id: session.id)

      return if order.nil?

      order.update(status: :failed)
    end
  end
end
