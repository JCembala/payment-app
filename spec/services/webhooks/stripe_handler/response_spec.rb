require "rails_helper"

RSpec.describe Webhooks::StripeHandler::Response do
  describe "#initialize" do
    it "initializes the response object" do
      response = described_class.new(status: 200, message: "Success")

      expect(response.status).to eq(200)
      expect(response.message).to eq("Success")
    end
  end
end
