module Api
  module V1
    class UsersController < ActionController::API
      def create
        if params[:email].present?
          UserWorker.perform_async(email: params[:email], note: params[:note])
          render json: {error: nil}, status: 200
        else
          render json: {error: "An email is required."}, status: 422
        end
      end
    end
  end
end
#todo dont forget strong params
