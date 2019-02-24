module Mirroring
  module User
    class Create
      attr_reader :internal_user

      def initialize(**params)
        @internal_user = ::User.new(email: params[:email].presence)
      end

      def mirror_and_save_user
        if @internal_user.valid?
          return false if mirroring_user_failed?
          @internal_user.save
          @internal_user
        end
      end

      #
      # List all supported external services where User will be created
      #
      def supported_mirrors
         [Hubspot]
      end

      private

      def mirroring_user_failed?
        process_external_mirroring.include? false
      end

      def process_external_mirroring
        supported_mirrors.map do |mirror|
          mirror.create_user(email: @internal_user.email)
        end
      end

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
