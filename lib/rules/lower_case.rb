module Rules
  class LowerCase
    class << self
      def type
        Rules::Constants::RULE_TYPE_TRANSFORM
      end

      def process(value)
        return nil unless value

        if value.is_a?(String)
          value.downcase
        elsif value.is_a?(Array)
          lower_for_string_list(value)
        end
      end

      private
      def lower_for_string_list(list)
        list.map { |item| item.is_a?(String) ? item.downcase : item}
      end
    end
  end
end
