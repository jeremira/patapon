module External
  class Hubspot

    def self.create_user(email:, note: nil)
      config_api
      contact = ::Hubspot::Contact.create!(email)
      add_note(contact_id: contact.vid, note: note) if note.presence
      contact
    rescue ::Hubspot::RequestError, ::Hubspot::ConfigurationError
      false
    end

    def self.add_note(contact_id:, note:)
      return false unless contact_id.presence && note.presence
      config_api
      ::Hubspot::EngagementNote.create!(contact_id, note)
    rescue ::Hubspot::RequestError, ::Hubspot::ConfigurationError
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
