module Api
  class BaseController < ActionController::API
    include Api::Response
    include Api::ExceptionHandler

    def catch_404
      raise ActionController::RoutingError, "/api/#{params[:path]}"
    end
  end
end
