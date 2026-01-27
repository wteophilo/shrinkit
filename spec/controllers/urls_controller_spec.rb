require 'rails_helper'

RSpec.describe "UrlsController", type: :request do
  # Create a valid record to be used in show/redirect tests
  let!(:url_record) { Url.create!(long_url: "https://google.com", short_code: "abc") }

  # Attributes for the create action
  let(:valid_attributes) { { url: { long_url: "https://github.com" } } }
  let(:invalid_attributes) { { url: { long_url: "" } } }


  describe "GET /index" do
    it "returns a successful response and lists the URLs" do
      get urls_path
      expect(response).to be_successful
      expect(response.body).to include(url_record.short_code)
    end
  end

  describe "GET /show" do
    it "returns a successful response" do
      get url_path(url_record)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Url" do
        expect {
          post urls_path, params: valid_attributes
        }.to change(Url, :count).by(1)
      end

      it "redirects to the created url" do
        post urls_path, params: valid_attributes
        expect(response).to redirect_to(url_url(Url.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Url and returns unprocessable content" do
        expect {
          post urls_path, params: invalid_attributes
        }.to change(Url, :count).by(0)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /redirect" do
    context "when the short_code exists" do
      it "redirects to the long_url with allow_other_host: true" do
        get "/urls/redirect/#{url_record.short_code}"
        expect(response).to redirect_to(url_record.long_url)
      end
    end

    context "when the short_code does not exist" do
      it "returns status 404 (Not Found)" do
        get "/non-existent-code"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
