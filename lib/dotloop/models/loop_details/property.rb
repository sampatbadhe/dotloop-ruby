# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class Property
        include Virtus.model
        attribute :bedrooms
        attribute :year_built
        attribute :square_footage
        attribute :type
        attribute :bathrooms
        attribute :school_district
        attribute :lot_size
      end
    end
  end
end
