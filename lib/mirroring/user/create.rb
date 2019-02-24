module Mirroring
  module User
    class Create
      attr_reader :internal_user

      def initialize(**params)
        @internal_user = ::User.new(email: params[:email].presence)
      end

      def mirror_and_save_user

      end

      #
      # List all supported external services where User will be created
      #
      def supported_mirrors
         [:hubspot]
      end

      private

      def create_and_mirror_user
        # build user
        # if user valid
        #  for all mirror services : mirror_user
        #Hubspot::User::Create.new()
        # if only valid
        # save user

        # return user > all was fine
        # return nil/false > something fail
      end
    end
  end
end
