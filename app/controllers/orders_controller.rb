class OrdersController < ApplicationController
  def create
    session =
      StripeIntegration::CheckoutCreator
        .call(package_id: params[:package_id], user: current_user)

    redirect_to session.url, allow_other_host: true, status: 303
  end

  def index
    @orders = current_user.orders
  end
end
