module Api
  module Response
    extend ActiveSupport::Concern

    included do
      def json_response(object, status = :ok)
        render json: object, status: status, root: false
      end
    end
  end
end
