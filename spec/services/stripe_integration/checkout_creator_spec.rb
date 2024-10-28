require "rails_helper"

RSpec.describe StripeIntegration::CheckoutCreator do
  describe ".call" do
    it "creates a new Stripe Checkout session" do
      user = create(:user)
      package = create(:package)

      session =
        double(
          Stripe::Checkout::Session,
          id: "session_id",
          url: "session_url"
        )

      allow(Stripe::Checkout::Session)
        .to receive(:create)
        .and_return(session)

      result = described_class.call(package_id: package.id, user: user)

      expect(result).to eq(session)
    end

    it "creates a new Order" do
      user = create(:user)
      package = create(:package)

      session =
        double(
          Stripe::Checkout::Session,
          id: "session_id",
          url: "session_url"
        )

      allow(Stripe::Checkout::Session)
        .to receive(:create)
        .and_return(session)

      expect { described_class.call(package_id: package.id, user: user) }
        .to change(Order, :count).by(1)

      expect(Order.last.stripe_session_id).to eq("session_id")
    end
  end
end
