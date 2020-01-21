# frozen_string_literal: true

namespace :tracking_data do
  desc "Get data from supplier and process data"
  task track_hotel_data: :environment do
    suppliers = Supplier.all.pluck(:url)

    suppliers.each do |supplier|
      Trackers::HotelTracker.new(supplier).process
    end
  end
end
