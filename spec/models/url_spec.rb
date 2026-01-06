require "rails_helper"

RSpec.describe Url, type: :model do
  context "is valid" do
    it "with a present long_url" do
      url = FactoryBot.build(:url, long_url: "https://a-long-but-valid-url.com/path")
      expect(url).to be_valid
    end
  end

  context 'validations' do
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

    it 'is valid with a properly formatted URL' do
      url = Url.new(long_url: 'https://github.com')
      expect(url).to be_valid
    end

    it 'is invalid with an improperly formatted URL' do
      url = Url.new(long_url: 'not-a-valid-url')
      expect(url).not_to be_valid
      expect(url.errors[:long_url]).to be_present
    end
  end
end
