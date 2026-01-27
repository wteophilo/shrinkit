module Urls
  module ShortCode
    class FindEncodeUrl
      include DomainEvent::Subscriber

      handles_event "url.encode.find"

      def call(event)
        id = event.payload[:id]
        short_code = event.payload[:short_code]
        long_url = event.payload[:long_url]
      end
    end
  end
end
