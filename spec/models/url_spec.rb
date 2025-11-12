require "rails_helper"

RSpec.describe Url, type: :model do
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
  end
end
