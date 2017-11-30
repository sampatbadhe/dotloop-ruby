# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class Contact
        include Virtus.model
        attribute :role
        attribute :cell_phone
        attribute :city
        attribute :company_name
        attribute :country
        attribute :email
        attribute :fax
        attribute :id
        attribute :license
        attribute :marital_status
        attribute :name
        attribute :phone
        attribute :state_prov
        attribute :street_name
        attribute :street_number
        attribute :unit_number
        attribute :zip_or_postal_code
      end
    end
  end
end
