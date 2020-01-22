require "rails_helper"

Rails.application.load_tasks

describe "tracking_data.rake" do
  it "should save successfully data to database" do
    VCR.use_cassette "get hotels_data from supplier 1fva3m", record: :once do
      create(:supplier, url: 'https://api.myjson.com/bins/1fva3m')

      Rake::Task["tracking_data:track_hotel_data"].invoke
      expected_result = {"id"=>"SjyX", "name"=>"InterContinental", "images"=>{"site"=>[{"link"=>"https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i1_m.jpg", "description"=>"Restaurant"}, {"link"=>"https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i2_m.jpg", "description"=>"Hotel Exterior"}, {"link"=>"https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i5_m.jpg", "description"=>"Entrance"}, {"link"=>"https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i24_m.jpg", "description"=>"Bar"}], "rooms"=>[{"link"=>"https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i93_m.jpg", "description"=>"Double room"}, {"link"=>"https://d2ey9sqrvkqdfs.cloudfront.net/Sjym/i94_m.jpg", "description"=>"Bathroom"}]}, "location"=>{"address"=>"1 Nanson Rd, Singapore 238909", "country"=>"Singapore"}, "amenities"=>{"room"=>["aircon", "minibar", "tv", "bathtub", "hair dryer"], "general"=>["outdoor pool", "business center", "childcare", "parking", "bar", "dry cleaning", "wifi", "breakfast", "concierge"]}, "description"=>"InterContinental Singapore Robertson Quay is luxury's preferred address offering stylishly cosmopolitan riverside living for discerning travelers to Singapore. Prominently situated along the Singapore River, the 225-room inspiring luxury hotel is easily accessible to the Marina Bay Financial District, Central Business District, Orchard Road and Singapore Changi International Airport, all located a short drive away. The hotel features the latest in Club InterContinental design and service experience, and five dining options including Publico, an Italian landmark dining and entertainment destination by the waterfront.", "destination_id"=>5432, "booking_conditions"=>[]}

      expect(Hotel.count).to eq(3)
      expect(Hotel.find_by(hotel_id:'SjyX', destination_id: 5432)&.detail).to eq(expected_result)
    end
  end
end

