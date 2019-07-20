# frozen_string_literal: true

module Dotloop
  module Models
    class Participant
      include Virtus.model
      attribute :cell_phone
      attribute :city
      attribute :company_name
      attribute :country
      attribute :email
      attribute :full_name
      attribute :id, Integer
      attribute :phone
      attribute :role
      attribute :state_prov
      attribute :street_name
      attribute :street_number
      attribute :unit_number
      attribute :zip_postal_code

      attr_accessor :client
      attr_accessor :loop_id
      attr_accessor :profile_id
    end
  end
end
