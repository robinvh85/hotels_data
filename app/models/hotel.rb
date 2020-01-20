class Hotel < ApplicationRecord
  validates :hotel_id, presence: true
  validates :destination_id, presence: true
end
