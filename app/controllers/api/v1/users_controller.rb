module Api
  module V1
    class UsersController < ActionController::API
      def create
        if params[:email].present?
          Mirroring::UserCreate.new(email: params[:email])
          render json: {error: nil}, status: 200
        else
          render json: {error: "An email is required."}, status: 422
        end
      end
    end
  end
end
