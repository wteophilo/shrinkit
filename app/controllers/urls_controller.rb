class UrlsController < ApplicationController
  before_action :set_url, only: %i[show]

  def index
    @urls = Url.all
  end

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    if @url.long_url.blank?
      flash.now[:alert] = "Please provide a URL to shorten."
      render :new, status: :unprocessable_entity
      return
    end

    @url.short_code = generate_short_code
    @short_url = "#{request.base_url}/#{@url.short_code}"

    return render :new, status: :unprocessable_entity unless @url.save
    redirect_to urls_path(@url)
  end

  def show
  end

 private
  def url_params
    params.expect(url: [:long_url, :short_code])
  end

  def generate_short_code
    next_id = Url.count + 1
    EncodedService.new.encoded(next_id)
  end

  def set_url
    @url = Url.last
  end
end
