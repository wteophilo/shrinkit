class EncodedService
  DEFAULT_MAX_LENGTH = 4

  def initialize(alphabet: ENV["ALPHABET"], secret: ENV["MY_SECRET_KEY"], max_length: DEFAULT_MAX_LENGTH)
    raise "Missing Hashid Salt" if secret.nil? || secret.empty?

    @alphabet = alphabet
    @secret = secret
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
