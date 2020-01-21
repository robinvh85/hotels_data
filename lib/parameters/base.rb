# frozen_string_literal: true

module Parameters
  class Base
    include ActiveModel::Validations

    def initialize(params = ActionController::Parameters.new)
      data_fields.each do |field|
        self.class.send(:attr_accessor, field)
        instance_variable_set("@#{field}".to_sym, params[field])
      end
    end

    def data_fields
      []
    end
  end
end
