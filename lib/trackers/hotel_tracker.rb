module Trackers
  class HotelTracker
    include Rules

    HOTEL_SCHEMA_MAP = {
      id: %i[Id hotel_id id],
      destination_id: %i[DestinationId destination_id destination],
      name: %i[Name hotel_name name],
      location: {
        lat: %i[Latitude lat],
        lng: %i[Longitude lng],
        address: %i[Address location.address address],
        city: %i[City],
        country: %i[Country location.country]
      },
      description: %i[Description details info],
      amenities: {
        general: %i[Facilities amenities.general],
        room: %i[amenities.room amenities]
      },
      images: {
        rooms: %i[images.rooms],
        site: %i[images.site],
        amenities: %i[images.amenities]
      },
      booking_conditions: %i[booking_conditions]
    }.freeze

    HOTEL_SCHEMA_RULES = {
      id: [TrimString, BetterLength],
      destination_id: [BetterLength],
      name: [TrimString, BetterLength],
      location: {
        lat: [BetterLength],
        lng: [BetterLength],
        address: [TrimString, BetterLength],
        city: [TrimString, BetterLength],
        country: [TrimString, BetterLength]
      },
      description: [TrimString, BetterLength],
      amenities: {
        general: [TrimString, LowerCase, BetterLength],
        room: [TrimString, LowerCase, BetterLength]
      },
      images: {
        rooms: [ImageList, MergingList],
        site: [ImageList, MergingList],
        amenities: [ImageList, MergingList]
      },
      booking_conditions: [TrimString, BetterLength]
    }.freeze

    def initialize(supplier=nil)
      @supplier = supplier
    end

    def process
      hotel_mapped_keys = Utils.build_map_keys(HOTEL_SCHEMA_MAP)
      raw_hotels_data = get_data_from_supplier
      return unless raw_hotels_data.is_a?(Array)

      raw_hotels_data.each do |raw_data|
        # sanitize raw data
        hash_data = Utils.convert_to_dotted_hash(raw_data)
        clean_hotel_data = Utils.transform_data_with_map(hash_data, hotel_mapped_keys)

        # transform, merge data and save data
        merge_and_save(clean_hotel_data)
      end
    end

    private
    def get_data_from_supplier
      puts "Get data from: #{@supplier}"
      uri = URI(@supplier)
      response = Net::HTTP.get_response(uri)

      if response.code == '200'
        JSON.parse(response.body)
      else
        nil
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
      nil
    end

    def merge_and_save(new_hotel_data)
      current_hotel = Hotel.find_by(hotel_id: new_hotel_data['id'], destination_id: new_hotel_data['destination_id'])
      if current_hotel.nil?
        current_hotel = Hotel.new({
          hotel_id: new_hotel_data['id'],
          destination_id: new_hotel_data['destination_id'],
          detail: {}
        })
      end

      current_hotel.detail = process_data(HOTEL_SCHEMA_RULES, current_hotel.detail, new_hotel_data)
      current_hotel.save
    end

    def process_data(schema_rules, current_data, new_data)
      new_data.keys.each do |field|
        if schema_rules.key?(field.to_sym)
          if new_data[field].is_a?(Hash)
            current_data[field] = {} unless current_data[field]
            current_data[field] = process_data(schema_rules[field.to_sym], current_data[field], new_data[field])
          else
            rules = schema_rules[field.to_sym]
            rules.each do |rule|
              if rule.type == Rules::Constants::RULE_TYPE_TRANSFORM
                new_data[field] = rule.send('process', new_data[field])
              else
                current_data[field] = rule.send('process', current_data[field], new_data[field])
              end
            end
          end
        end
      end

      current_data
    end
  end
end
