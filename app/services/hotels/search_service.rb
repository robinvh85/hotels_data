module Hotels
  class SearchService
    def initialize(hotel_ids=nil, destination_id=nil)
      @hotel_ids = hotel_ids
      @destination_id = destination_id
    end

    def perform
      query = Hotel.all
      query = query.where(destination_id: @destination_id) if @destination_id.present?
      query = query.where(hotel_id: @hotel_ids) if @hotel_ids.present?
      query.pluck(:detail)
    end
  end
end
