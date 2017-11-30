# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class GeographicDescription
        include Virtus.model

        attribute :addition
        attribute :block
        attribute :deed_book
        attribute :deed_page
        attribute :lot
        attribute :map_grid
        attribute :mls_area
        attribute :mls_legal_description
        attribute :section
        attribute :subdivision
      end
    end
  end
end
