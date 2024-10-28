module Webhooks
  class StripeHandler
    class Response
      attr_reader :status, :message

      def initialize(status:, message:)
        @status = status
        @message = message
      end
    end
  end
end
