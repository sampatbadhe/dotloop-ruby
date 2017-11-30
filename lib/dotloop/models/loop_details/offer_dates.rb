# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class OfferDates
        include Virtus.model
        attribute :offer_date
        attribute :inspection_date
        attribute :occupancy_date
        attribute :offer_expiration_date
      end
    end
  end
end
