# frozen_string_literal: true

module Dotloop
  class LoopDetail
    attr_accessor :details
    FIXED_SECTIONS = %i[
      contract_dates contract_info financials geographic_description
      listing_information offer_dates property_address property referral
    ].freeze

    def initialize(data)
      @details = FIXED_SECTIONS.each_with_object({}) { |key, memo| memo[key] = {} }.merge(contacts: [])
      parse_data(data)
    end

    def parse_data(data)
      fix_hash_keys(data).each { |item| build_section(item[0], item[1]) }
    end

    private

    def build_section(key, section_data)
      return unless FIXED_SECTIONS.include?(key)
      values = fix_hash_keys(section_data)
      @details[key] = values
    end

    def index_to_key(index)
      index.to_s.downcase.delete(%(')).gsub(/%/, ' percent ').gsub(/\$/, ' doller ').gsub(/[^a-z]/, '_').squeeze('_').gsub(/^_*/, '').gsub(/_*$/, '').to_sym
    end

    def fix_hash_keys(bad_hash)
      bad_hash.each_with_object({}) do |item, memo|
        memo[index_to_key(item[0])] = item[1]
      end
    end
  end
end
