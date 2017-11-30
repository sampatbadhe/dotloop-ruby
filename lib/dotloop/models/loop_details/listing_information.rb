# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class ListingInformation
        include Virtus.model
        attribute :property_excludes
        attribute :description_of_other_liens
        attribute :expiration_date
        attribute :listing_date
        attribute :total_encumbrances
        attribute :property_includes
        attribute :remarks
        attribute :current_price
        attribute :first_mortgage_balance
        attribute :homeowners_association
        attribute :second_mortgage_balance
        attribute :original_price
        attribute :other_liens
        attribute :homeowners_association_dues
      end
    end
  end
end
