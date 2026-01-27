module Urls
  class Create
    def initialize(params)
      @params = params
    end

    def call
      @url = Url.new(@params)
      if @url.save
        update_short_code(@url)
        publish_url_encoded_event(@url)
        Result.success(@url)
      else
        Result.failure(@url.errors.full_messages)
      end
    end

    private

    def publish_url_encoded_event(url)
      ActiveSupport::Notifications.instrument("url.created",
        short_code: @url.short_code,
        long_url: @url.long_url,
        encoded_at: Time.current
      )
    end

    def update_short_code(url)
      short_code = generate_short_code(url.id)
      url.update_column(:short_code, short_code)
    end

    def generate_short_code(id)
      Encode.new.generate(id)
    end
  end
end
