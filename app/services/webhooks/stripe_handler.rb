module Webhooks
  class StripeHandler
    def self.call(...)
      new(...).call
    end

    def initialize(request:)
      @request = request
      @event = nil
    end

    def call
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']

      begin
        @event = Stripe::Webhook.construct_event(
          payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET']
        )
      rescue JSON::ParserError => e
        return Response.new(status: 422, message: e.message)
      rescue Stripe::SignatureVerificationError => e
        return Response.new(status: 401, message: e.message)
      end

      case event['type']
      when 'checkout.session.completed'
        handle_checkout_completed
      when 'checkout.session.expired'
        handle_checkout_expired
      end

      Response.new(status: 200, message: 'Successfully processed event')
    end

    private

    attr_accessor :request, :event

    def order
      @order ||= Order.find_by(stripe_session_id: session_id)
    end

    def session_id
      event['data']['object']['id']
    end

    def handle_checkout_completed
      return if order.nil?

      order.update(status: :paid)
      OrderMailer.checkout_complete(order).deliver_now
    end

    def handle_checkout_expired
      return if order.nil?

      order.update(status: :failed)
      OrderMailer.checkout_expired(order).deliver_now
    end
  end
end
