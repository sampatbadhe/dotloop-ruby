# frozen_string_literal: true

module Dotloop
  class Contact
    include Dotloop::QueryParamHelpers
    attr_accessor :client

    CONTACT_FIELDS = %w[firstName lastName email home office
                        fax address city zipCode state country].freeze

    def initialize(client:)
      @client = client
    end

    def all(options = {})
      contacts = []
      url = '/contact'
      (1..MAX_CONTACTS).each do |i|
        options[:batch_number] = i
        current_contacts = @client.get(url, query_params(options))[:data].map do |contact_attrs|
          Dotloop::Models::Contact.new(contact_attrs)
        end
        contacts += current_contacts
        break if current_contacts.size < BATCH_SIZE
      end
      contacts
    end

    def find(contact_id:)
      contact_data = @client.get("/contact/#{contact_id.to_i}")[:data]
      Dotloop::Models::Contact.new(contact_data)
    end

    def create(params: {})
      data = {}
      params.each do |key, value|
        CONTACT_FIELDS.include?(key.to_s) || next
        data[key] = value
      end

      contact_data = @client.post("/contact", data)[:data]
      Dotloop::Models::Contact.new(contact_data)
    end

    def update(contact_id:, params: {})
      data = {}
      params.each do |key, value|
        CONTACT_FIELDS.include?(key.to_s) || next
        data[key] = value
      end

      contact_data = @client.patch("/contact/#{contact_id.to_i}", data)[:data]
      Dotloop::Models::Contact.new(contact_data)
    end

    def delete(contact_id:)
      @client.delete("/contact/#{contact_id.to_i}")
    end

    private

    def query_params(options)
      {
        batch_number:        batch_number(options),
        batch_size:          batch_size(options),
        filter:              options[:filter]
      }.delete_if { |_, v| should_delete(v) }
    end
  end
end
