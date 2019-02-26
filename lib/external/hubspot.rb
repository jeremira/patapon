module External
  class Hubspot

    def self.create_user(email:)
      config_api
      ::Hubspot::Contact.create!(email)
    rescue
      false
    end

    private

    def self.config_api
      @config ||= ::Hubspot.configure(
        Rails.application.config.external_api[:hubspot]
      )
    end
  end
end
