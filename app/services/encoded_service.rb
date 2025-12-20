class EncodedService
  ALPHABET = ENV["ALPHABET"]
  MY_SECRET = ENV["MY_SECRET_KEY"]
  MAX_LENGTH = 4

  def initialize
    @hashid = Hashids.new(MY_SECRET, MAX_LENGTH, ALPHABET)
  end

  def encoded(long_url)
    @hashid.encode(long_url)
  end

  def decode(long_url)
    @hashid.decode(long_url)
  end
end
