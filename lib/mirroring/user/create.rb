module Mirroring
  module User
    class Create
      attr_reader :internal_user

      def initialize(params={})
        params.symbolize_keys!
        @internal_user = ::User.new(
          email: params[:email].presence,
          note: params[:note].presence
        )
      end

      #
      # Mirror valid User instance in external services
      # before to persist it in DB
      #
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
         [External::Hubspot]
      end

      private

      #
      # Return false if one of the external creation process failed
      #
      def mirroring_user_failed?
        process_external_mirroring.include? false
      end

      #
      # Will create user in each external services
      #
      def process_external_mirroring
        supported_mirrors.map do |mirror|
          mirror.create_user(
            email: @internal_user.email,
            note: @internal_user.note
          )
        end
      end
    end
  end
end
