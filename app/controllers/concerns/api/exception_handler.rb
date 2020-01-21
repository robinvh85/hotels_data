module Api
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |e|
        json_response({ message: e.message }, :internal_server_error)
      end

      rescue_from Errors::ParameterError do |exception|
        json_response(
          {
            message: exception.message,
            errors: exception.error_messages
          }, :bad_request
        )
      end

      rescue_from ActionController::RoutingError do |e|
        json_response({ message: "Not found URI '#{e.message}'" }, :not_found)
      end
    end
  end
end
