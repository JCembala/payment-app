require "rails_helper"

RSpec.describe Webhooks::StripeController, type: :controller do
  describe "POST #create" do
    it "calls the StripeHandler" do
      expected_response =
        Webhooks::StripeHandler::Response.new(message: "Success", status: 200)

      allow(Webhooks::StripeHandler)
        .to receive(:call)
        .and_return(expected_response)

      post :create

      expect(Webhooks::StripeHandler).to have_received(:call)
    end

    context "when the StripeHandler returns a success response" do
      it "returns a success response" do
        expected_response =
          Webhooks::StripeHandler::Response.new(message: "Success", status: 200)

        allow(Webhooks::StripeHandler)
          .to receive(:call)
                .and_return(expected_response)

        post :create

        expect(response).to be_successful
        expect(response.body).to eq({ message: "Success" }.to_json)
      end
    end

    context "when the StripeHandler returns a failure response" do
      it "returns a failure response" do
        expected_response =
          Webhooks::StripeHandler::Response.new(message: "Failure", status: 422)

        allow(Webhooks::StripeHandler)
          .to receive(:call)
          .and_return(expected_response)

        post :create

        expect(response).to have_http_status(422)
        expect(response.body).to eq({ message: "Failure" }.to_json)
      end
    end
  end
end
