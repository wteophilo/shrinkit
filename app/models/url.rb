class Url < ApplicationRecord
  validates :long_url, presence: true
end
