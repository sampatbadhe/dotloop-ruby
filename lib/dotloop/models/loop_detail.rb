# frozen_string_literal: true

module Dotloop
  module Models
    class LoopDetail
      include Virtus.model
      attribute :contract_dates,         Dotloop::Models::LoopDetails::ContractDates
      attribute :contract_info,          Dotloop::Models::LoopDetails::ContractInfo
      attribute :financials,             Dotloop::Models::LoopDetails::Financials
      attribute :geographic_description, Dotloop::Models::LoopDetails::GeographicDescription
      attribute :listing_information,    Dotloop::Models::LoopDetails::ListingInformation
      attribute :offer_dates,            Dotloop::Models::LoopDetails::OfferDates
      attribute :property_address,       Dotloop::Models::LoopDetails::PropertyAddress
      attribute :property,               Dotloop::Models::LoopDetails::Property
      attribute :referral,               Dotloop::Models::LoopDetails::Referral
      attribute :contacts,               Array[Dotloop::Models::LoopDetails::Contact]

      attr_accessor :profile_id
      attr_accessor :loop_id
    end
  end
end
