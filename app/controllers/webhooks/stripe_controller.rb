module Webhooks
  class StripeController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      response = ::Webhooks::StripeHandler.call(request:)

      render json: { message: response.message }, status: response.status
    end
  end
end
