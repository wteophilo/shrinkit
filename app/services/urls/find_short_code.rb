module Urls
  class FindShortCode
    def initialize(short_code)
      @short_code = short_code
    end

    def call
      url = Url.find_by(short_code: @short_code)
      if url
        publish_url_find_encoded_event(url)
        Result.success(url)
      else
        Result.failure([ I18n.t("urls.show.error") ])
      end
    end


    private

    def publish_url_find_encoded_event(url)
      ActiveSupport::Notifications.instrument("url.finded_enconded_url",
        id: url.id,
        short_code: url.short_code,
        long_url: url.long_url
      )
    end
  end
end
