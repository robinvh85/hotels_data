class Utils
  class << self
    # Description: convert a nested hash to a unnested hash
    # Example:
    #   Input: {people: {person: {name: 'My Name'}}}
    #   Output: {"people.person.name"=>"My Name"}
    def convert_to_dotted_hash(data_hash, parent_key = nil)
      return {} unless data_hash.is_a?(Hash)

      result = {}

      data_hash.each do |key, value|
        tmp_key = parent_key ? "#{parent_key}.#{key.to_s}" : key.to_s
        if value.is_a?(Hash)
          result.merge!(convert_to_dotted_hash(value, tmp_key))
        else
          result[tmp_key] = value
        end
      end

      result
    end

    # Example:
    #   Input: {id: %i[Id hotel_id id]}
    #   Output: {"Id"=>"id", "hotel_id"=>"id", "id"=>"id"}
    def build_map_keys(schema_keys, parent_key=nil)
      return {} unless schema_keys.is_a?(Hash)

      result = {}
      schema_keys.keys.each do |key|
        full_key = parent_key ? "#{parent_key}.#{key}".to_s : key.to_s

        if schema_keys[key].is_a?(Array)
          schema_keys[key].each do |field|
            result[field.to_s] = full_key
          end
        else
          result.merge!(build_map_keys(schema_keys[key], full_key))
        end
      end

      result
    end

    # Description: merge to an nested hash
    # Example:
    #   Input: {"other"=>"value"}, "people.person.name", "My Name"
    #   Output: {"other"=>"value", "people"=>{"person"=>{"name"=>"My Name"}}}
    def merge_nested_hash_with_key(data_hash, key, value)
      return {} if !data_hash.is_a?(Hash) || key.nil? || key.empty?

      tmp_hash = data_hash
      keys = key.split('.')
      keys.each_with_index do |key_item, index|
        if index == keys.length - 1
          tmp_hash[key_item] = value
        else
          tmp_hash[key_item] = {} unless tmp_hash[key_item].is_a?(Hash)
          tmp_hash = tmp_hash[key_item]
        end
      end

      data_hash
    end

    # Example:
    #   Input: {"Latitude"=>1.2}, {"Latitude"=>"location.lat"}
    #   Output: {"location"=>{"lat"=>1.2}}
    def transform_data_with_map(data_hash, mapped_keys)
      return {} if !data_hash.is_a?(Hash) || !mapped_keys.is_a?(Hash)

      result = {}
      data_hash.keys.each do |key|
        if mapped_keys.key?(key)
          if mapped_keys[key].include?('.')
            Utils.merge_nested_hash_with_key(result, mapped_keys[key], data_hash[key])
          else
            result[mapped_keys[key]] = data_hash[key]
          end
        end
      end

      result
    end
  end
end
