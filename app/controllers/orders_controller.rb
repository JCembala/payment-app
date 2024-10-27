class OrdersController < ApplicationController
  def create
    package = Package.find(params[:package_id]) || Package.first

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: current_user.email,
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
      cancel_url: payment_cancel_url
    )

    @order = Order.create(user: User.first, package: package, status: 'pending', stripe_session_id: session.id)

    redirect_to session.url, allow_other_host: true, status: 303
  end

  def index
    @orders = current_user.orders
  end
end
