require 'rails_helper'

RSpec.describe EncodedService, type: :service do
  let(:default_alphabet) { "abcdefghijklmnopqrstuvwxyz1234567890" }
  let(:default_secret) { "super-secret-salt" }
  let(:service) { described_class.new }
  let(:id) { 12345 }

  # Stubbing ENV to ensure tests are isolated from your local machine settings
  before do
    allow(ENV).to receive(:[]).with("ALPHABET").and_return(default_alphabet)
    allow(ENV).to receive(:[]).with("MY_SECRET_KEY").and_return(default_secret)
  end

  describe "#initialize" do
    context "when no arguments are passed" do
      it "uses values from environment variables" do
        service = described_class.new
        # We check if the internal state matches the ENV values
        expect(service.instance_variable_get(:@secret)).to eq(default_secret)
        expect(service.instance_variable_get(:@alphabet)).to eq(default_alphabet)
      end
    end

    context "when custom arguments are passed" do
      it "overrides the environment variables" do
        custom_secret = "custom-salt"
        service = described_class.new(secret: custom_secret)

        expect(service.instance_variable_get(:@secret)).to eq(custom_secret)
        expect(service.instance_variable_get(:@alphabet)).to eq(default_alphabet)
      end
    end

    context "when secret is missing" do
      it "overrides the environment variable with a default value" do
        default_secret = "fallback_for_dev_only"
        allow(ENV).to receive(:[]).with("MY_SECRET_KEY").and_return(nil)
        expect(service.instance_variable_get(:@secret)).to eq(default_secret)
      end
    end
  end

  describe '#encoded' do
    it "encodes an integer into a hash string" do
      result = service.encode(id)

      expect(result).to be_a(String)
      expect(result).not_to be_empty
    end

    it "returns different hashes for different secrets" do
      service_a = described_class.new(secret: "salt-a")
      service_b = described_class.new(secret: "salt-b")

      expect(service_a.encode(id)).not_to eq(service_b.encode(id))
    end
  end

  describe "#decoding" do
    it "decodes a hash back to the original integer" do
      hash = service.encode(id)
      decoded_value = service.decode(hash)

      # Hashids returns an array on decode (e.g., [12345])
      expect(decoded_value).to eq([ id ])
    end
  end
end
