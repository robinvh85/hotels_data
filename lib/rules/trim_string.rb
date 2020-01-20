module Rules
  class TrimString
    class << self
      def type
        Rules::Constants::RULE_TYPE_TRANSFORM
      end

      def process(value)
        return value if !value || value.is_a?(Numeric)

        trim_value(value)
      end

      private
      def trim_string_with_array(array)
        array.map do |value|
          trim_value(value)
        end
      end

      def trim_string_with_hash(hash)
        hash.keys.each do |key|
          hash[key] = trim_value(hash[key])
        end

        hash
      end

      def trim_value(value)
        if value.is_a?(String)
          value.strip
        elsif value.is_a?(Array)
          trim_string_with_array(value)
        elsif value.is_a?(Hash)
          trim_string_with_hash(value)
        else
          value
        end
      end
    end
  end
end
