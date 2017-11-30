# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class PropertyAddress
        include Virtus.model
        attribute :city
        attribute :county
        attribute :country
        attribute :mls_number
        attribute :parcel_tax_id
        attribute :state_prov
        attribute :street_name
        attribute :street_number
        attribute :unit_number
        attribute :zip_postal_code
      end
    end
  end
end
