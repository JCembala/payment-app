module StripeIntegration
  class CheckoutCreator
    include Rails.application.routes.url_helpers

    def self.call(...)
      new(...).call
    end

    def initialize(package_id:, user:)
      @package_id = package_id
      @user = user
    end

    def call
      create_session
      create_order

      session
    end

    private

    attr_reader :package_id, :user

    def package
      @package ||= Package.find(package_id)
    end

    def create_session
      @create_session ||= Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        customer_email: user.email,
        line_items:
          [{
             price_data: {
               currency: 'usd',
               product_data: {
                 name: package.name
               },
               unit_amount: package.price_cents,
               recurring: { interval: 'month' }
             },
             quantity: 1
           }],
        mode: 'subscription',
        success_url: payment_success_url,
        cancel_url: payment_cancel_url,
        expires_at: Time.now.to_i + 30.minutes.to_i
      )
    end

    def create_order
      Order.create(
        user:,
        package:,
        status: :pending,
        stripe_session_id: session.id
      )
    end

    alias_method :session, :create_session
  end
end
