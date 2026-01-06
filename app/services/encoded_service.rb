class EncodedService
  DEFAULT_MAX_LENGTH = 4

  def initialize(alphabet: nil, secret: nil, max_length: DEFAULT_MAX_LENGTH)
    @secret = secret || ENV["MY_SECRET_KEY"] || "fallback_for_dev_only"
    @alphabet = alphabet || ENV["ALPHABET"] || "abcdefghijklmnopqrstuvwxyz1234567890"

    raise "Missing Hashid Salt" if @secret.blank?

    @max_length = max_length

    @hashid = Hashids.new(@secret, @max_length, @alphabet)
  end

  def encode(long_url)
    @hashid.encode(long_url)
  end

  def decode(long_url)
    @hashid.decode(long_url)
  end
end
