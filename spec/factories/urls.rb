# spec/factories/urls.rb

FactoryBot.define do
  factory :url do
    long_url { 'http://www.default-valid-url.com/test' }
    # Add other attributes here if they exist in your model, like 'short_code'
  end
end
