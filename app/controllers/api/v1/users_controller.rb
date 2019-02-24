module Api
  module V1
    class UsersController < ActionController::API
      def create
        render json: "ok", status: 200
      end
    end
  end
end
