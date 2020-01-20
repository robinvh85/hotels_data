module Rules
  class ImageList
    URL_FIELDS = ['link', 'url']
    DESCRIPTION_FIELDS = ['description', 'caption']

    class << self
      def type
        Rules::Constants::RULE_TYPE_TRANSFORM
      end

      def process(images_list)
        return nil unless images_list.is_a?(Array)

        result = []
        images_list.each do |item|
          image_object = parse_image_object(item)
          next unless image_object

          result << image_object
        end

        result
      end

      private
      def parse_image_object(data_object)
        return nil unless data_object.is_a?(Hash)

        image_object = {'link' => nil, 'description' => nil}

        data_object.keys.each do |key|
          image_object['link'] = data_object[key] if URL_FIELDS.include?(key)
          image_object['description'] = data_object[key] if DESCRIPTION_FIELDS.include?(key)
        end

        image_object
      end
    end
  end
end
