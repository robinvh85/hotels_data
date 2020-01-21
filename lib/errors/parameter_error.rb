# frozen_string_literal: true

module Errors
  class ParameterError < StandardError
    attr_reader :message, :errors

    def initialize(errors)
      @message = 'Parameters Error'
      @errors = errors
    end

    def error_messages
      error_msgs = []

      @errors.each do |field, messages|
        error_msgs << Hash[field, messages[0]]
      end

      error_msgs
    end
  end
end
