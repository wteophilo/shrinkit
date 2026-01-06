class Url < ApplicationRecord
  before_validation :strip_long_url
  validates :long_url, presence: true, url: true

  private

  def strip_long_url
    self.long_url = long_url.to_s.strip if long_url.present?
  end
end
