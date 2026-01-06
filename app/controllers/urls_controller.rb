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
    @url.short_code = generate_short_code
    return render :new, status: :unprocessable_content unless @url.save
    redirect_to @url
  end

  def show
  end

  def redirect
    @url = Url.find_by!(short_code: params[:short_code])
    redirect_to @url.long_url, allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    render plain: t("urls.show.error"), status: :not_found
  end

 private

  def url_params
    params.expect(url: [ :long_url, :short_code ])
  end

  def generate_short_code
    next_id = Url.count + 1
    EncodedService.new.encode(next_id)
  end

  def set_url
    @url = Url.find(params[:id])
  end
end
