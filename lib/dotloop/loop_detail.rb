# frozen_string_literal: true

module Dotloop
  class LoopDetail
    include Dotloop::ParseData
    attr_accessor :details
    FIXED_SECTIONS = %i[
      contract_dates contract_info financials geographic_description
      listing_information offer_dates property_address property referral
    ].freeze

    def initialize(data)
      @details = FIXED_SECTIONS.each_with_object({}) { |key, memo| memo[key] = {} }.merge(contacts: [])
      parse_data(data)
    end

    private

    def fields
      FIXED_SECTIONS
    end
  end
end
