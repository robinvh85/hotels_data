FactoryBot.define do
  factory :hotel do
    hotel_id { "h1" }
    destination_id { 1 }
    detail { {"id"=>"abc", "destination_id"=>1, "name":"hotel 1"} }
  end
end
