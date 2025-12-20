require "base62"

module FormatHelpersBased62
  def formatted_based_62(long_url)
    long_url.base62_encode
  end

  def decode_based_62(long_url)
    long_url.base62_decode
  end
end
