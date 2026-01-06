class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      uri = URI.parse(value)
      valid_protocol = uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

      valid_host = uri.host.present? && uri.host.include?(".") && uri.host.length > 3

      unless valid_protocol && valid_host
        record.errors.add(attribute, :invalid_protocol, message: options[:message])
      end
    rescue URI::InvalidURIError
      record.errors.add(attribute, :invalid_url_format, message: options[:message])
    end
  end
end
