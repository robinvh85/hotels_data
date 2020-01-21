module Rules
  class BetterLength
    class << self
      def type
        Rules::Constants::RULE_TYPE_CHOICE
      end

      def process(old_value, new_value)
        return old_value unless new_value
        return new_value unless old_value

        old_value_length = old_value.is_a?(Numeric) ? old_value.to_s.length : old_value.length
        new_value_length = new_value.is_a?(Numeric) ? new_value.to_s.length : new_value.length
        return new_value if new_value_length > old_value_length

        old_value
      end
    end
  end
end
