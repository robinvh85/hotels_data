class Supplier < ApplicationRecord
  validates :url, presence: true
end
