module Urls
  module UrlCreate
    class EncodeUrl
      include DomainEvent::Subscriber

      handles_event "url.create.encode"

      def call(event)
        short_code = event.payload[:short_code]
        long_url = event.payload[:long_url]
        encoded_at = event.payload[:encoded_at]
      end
    end
  end
end
