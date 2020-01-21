# frozen_string_literal: true

module Parameters
  class HotelSearchParam < Base
    def data_fields
      [:hotel_ids, :destination_id]
    end

    validates :hotel_ids, presence: true, if: -> { destination_id.blank? }
    validates :destination_id, presence: true, if: -> { hotel_ids.blank? }

    def validate!
      raise Errors::ParameterError, self.errors.messages unless self.valid?
    end
  end
end
