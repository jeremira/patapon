module Mirroring
  module User
    class Create
      attr_reader :email

      def initialize(**params)
        @email = params[:email] || nil
        @supported_mirror = [:hubspot]
        create_and_mirror_user
      end

      private

      def create_and_mirror_user
        # build user
        # if user valid
        # 
      end
    end
  end
end
