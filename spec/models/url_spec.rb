require "rails_helper"

RSpec.describe Url, type: :model do
  describe "validations" do
    context "is valid" do
      it "with a present long_url" do
        url = FactoryBot.build(:url, long_url: "https://a-long-but-valid-url.com/path")
        expect(url).to be_valid
      end
    end

    context "is invalid" do
      it "without a long_url" do
        url = FactoryBot.build(:url, long_url: nil)

        url.valid?

        expect(url).to_not be_valid
        expect(url.errors[:long_url]).to include("can't be blank")
      end

      it "if long_url is an empty string" do
        url = FactoryBot.build(:url, long_url: "")
        url.valid?
        expect(url).to_not be_valid
        expect(url.errors[:long_url]).to include("can't be blank")
      end

      it "is valid with a properly formatted URL" do
        url = Url.new(long_url: "https://github.com")
        expect(url).to be_valid
      end

      it "is invalid with a malformed URL" do
        invalid_urls = [ "not-a-url", "www.missing-protocol.com", "http://space in url.com" ]

        invalid_urls.each do |invalid|
          url = Url.new(long_url: invalid)
          expect(url).not_to be_valid
          expect(url.errors[:long_url]).to be_present
        end
      end
    end
  end

  describe "callbacks" do
    context "before_validation" do
      it "removes leading and trailing whitespaces from long_url" do
        url = Url.new(long_url: "   https://spaced-url.com/path   ")
        url.valid?
        expect(url.long_url).to eq("https://spaced-url.com/path")
      end

      it "does not crash if long_url is nil" do
        url = Url.new(long_url: nil)
        expect { url.valid? }.not_to raise_error
      end
    end

    context "after_create" do
      it "generates and saves the short_code based on model id" do
        service_spy = instance_double(EncodedService)
        allow(EncodedService).to receive(:new).and_return(service_spy)
        allow(service_spy).to receive(:encode).and_return("abc123")

        url = FactoryBot.build(:url, long_url: "https://a-long-but-valid-url.com/path")

        expect { url.save }.to change { url.short_code }.from(nil).to("abc123")

        expect(service_spy).to have_received(:encode).with(url.id)
      end
    end
  end
end
