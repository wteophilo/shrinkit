class UrlsController < ApplicationController
  before_action :set_url, only: %i[show]

  def index
    @urls = Url.all
  end

  def new
    @url = Url.new
  end

  def create
    result = Urls::Create.new(url_params).call
    if result.success?
      redirect_to result.value
    else
      @url = Url.new(url_params)
      @url.errors.add(:base, result.errors.join(", "))
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def redirect
    result = Urls::FindShortCode.new(params[:short_code]).call
    if result.success?
      redirect_to result.value.long_url, allow_other_host: true
    else
      render plain: result.errors.join(", "), status: :not_found
    end
  end

 private

  def url_params
    params.expect(url: [ :long_url, :short_code ])
  end

  def set_url
    @url = Url.find(params[:id])
  end
end
