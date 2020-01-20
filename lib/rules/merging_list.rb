module Rules
  class MergingList
    class << self
      def type
        Rules::Constants::RULE_TYPE_CHOICE
      end

      def process(old_value, new_value)
        return old_value unless new_value.is_a?(Array)
        return new_value unless old_value

        (old_value | new_value).uniq
      end
    end
  end
end
