module Api
  class HotelsController < ::Api::BaseController
    def search
      hotel_param = Parameters::HotelSearchParam.new(params)
      hotel_param.validate!

      result = Hotels::SearchService.new(hotel_param.hotel_ids, hotel_param.destination_id).perform
      json_response(result)
    end
  end
end
