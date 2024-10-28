require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  describe "#create" do
    it "calls the CheckoutCreator" do
      expected_session =
        double(
          Stripe::Checkout::Session,
          url: "https://stripe.com"
        )

      allow(StripeIntegration::CheckoutCreator)
        .to receive(:call)
        .and_return(expected_session)

      post :create

      expect(StripeIntegration::CheckoutCreator).to have_received(:call)
    end

    it "redirects to the session URL" do
      expected_session =
        double(
          Stripe::Checkout::Session,
          url: "https://stripe.com"
        )

      allow(StripeIntegration::CheckoutCreator)
        .to receive(:call)
        .and_return(expected_session)

      post :create

      expect(response).to redirect_to("https://stripe.com")
    end
  end

  describe "#index" do
    it "assigns the user's orders" do
      user = create(:user)
      orders = create_list(:order, 2, user: user)

      get :index

      expect(assigns(:orders)).to eq(orders)
    end
  end
end
