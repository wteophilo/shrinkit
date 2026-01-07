class Url < ApplicationRecord
  before_validation :strip_long_url
  validates :long_url, presence: true, url: true

  after_create :generate_short_code

  private

  def strip_long_url
    self.long_url = long_url.to_s.strip if long_url.present?
  end

  def generate_short_code
      code = EncodedService.new.encode(self.id)
    self.update_column(:short_code, code)
  end
end
