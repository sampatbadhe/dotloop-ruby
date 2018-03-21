# frozen_string_literal: true

module Dotloop
  class Loop
    include Dotloop::QueryParamHelpers
    attr_accessor :client

    LOOP_FIELDS = %w[name status transactionType].freeze

    LOOP_DETAILS_FIELDS = {
      "Property Address" => [
        "Country", "Street Number", "Street Name", "Unit Number", "City",
        "State/Prov", "Zip/Postal Code", "County", "MLS Number", "Parcel/Tax ID"
      ],
      "Financials" => [
        "Purchase/Sale Price", "Sale Commission Rate",
        "Sale Commission Split % - Buy Side", "Sale Commission Split % - Sell Side",
        "Sale Commission Total", "Earnest Money Amount", "Earnest Money Held By",
        "Sale Commission Split $ - Buy Side", "Sale Commission Split $ - Sell Side"
      ],
      "Contract Dates" => [
        "Contract Agreement Date", "Closing Date"
      ],
      "Offer Dates" => [
        "Inspection Date", "Offer Date", "Offer Expiration Date", "Occupancy Date"
      ],
      "Contract Info" => [
        "Transaction Number", "Class", "Type"
      ],
      "Referral" => [
        "Referral %", "Referral Source"
      ],
      "Listing Information" => [
        "Expiration Date", "Listing Date", "Original Price",
        "Current Price", "1st Mortgage Balance", "2nd Mortgage Balance",
        "Other Liens", "Description of Other Liens", "Homeowner's Association",
        "Homeowner's Association Dues", "Total Encumbrances", "Property Includes",
        "Property Excludes", "Remarks"
      ],
      "Geographic Description" => [
        "MLS Area", "Legal Description", "Map Grid", "Subdivision", "Lot",
        "Deed Page", "Deed Book", "Section", "Addition", "Block"
      ],
      "Property" => [
        "Year Built", "Bedrooms", "Square Footage", "School District",
        "Type", "Bathrooms", "Lot Size"
      ]
    }.freeze

    def initialize(client:)
      @client = client
    end

    def all(options = {})
      raise_if_invalid_batch_size(options)
      options[:batch_size] ||= BATCH_SIZE
      Array.new.tap do |arr|
        (1..MAX_LOOPS).each do |i|
          options[:batch_number] = i
          current_batch = batch(options)
          arr.push current_batch
          break if current_batch.size < options[:batch_size]
        end
      end.flatten
    end

    def batch(options = {})
      @client.get("/profile/#{profile_id(options)}/loop", query_params(options))[:data].map do |attrs|
        lp = Dotloop::Models::Loop.new(attrs)
        lp.client = client
        lp.profile_id = profile_id(options)
        lp
      end
    end

    def find(profile_id:, loop_id:)
      loop_data = @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}")[:data]
      lp = Dotloop::Models::Loop.new(loop_data)
      lp.client = client
      lp.profile_id = profile_id.to_i
      lp
    end

    def detail(profile_id:, loop_id:)
      loop_detail = @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/detail")[:data]
      loop_detail = Dotloop::LoopDetail.new(loop_detail).details
      ld = Dotloop::Models::LoopDetail.new(loop_detail)
      ld.profile_id = profile_id.to_i
      ld.loop_id = loop_id.to_i
      ld
    end

    def create(profile_id:, params: {})
      data = {
        name: params['name'],
        status: params['status'],
        transactionType: params['transactionType']
      }

      loop_data = @client.post("/profile/#{profile_id.to_i}/loop", data)[:data]
      lp = Dotloop::Models::Loop.new(loop_data)
      lp.client = client
      lp.profile_id = profile_id.to_i
      lp
    end

    def loop_it(profile_id:, params: {})
      loop_data = @client.post("/loop-it?profile_id=#{profile_id}", params)[:data]
      lp = Dotloop::Models::Loop.new(loop_data)
      lp.client = client
      lp.profile_id = profile_id.to_i
      lp
    end

    def update(profile_id:, loop_id:, params: {})
      data = {}
      params.each do |key, value|
        LOOP_FIELDS.include?(key.to_s) || next
        data[key] = value.to_s
      end

      loop_data = @client.patch("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}", data)[:data]
      lp = Dotloop::Models::Loop.new(loop_data)
      lp.client = client
      lp.profile_id = profile_id.to_i
      lp
    end

    def update_details(profile_id:, loop_id:, params: {})
      data = {}
      LOOP_DETAILS_FIELDS.keys.each do |key|
        (detail_fields = params[key])
        detail_fields.is_a?(Hash) || next
        data[key] = {}
        detail_fields.each do |k, v|
          LOOP_DETAILS_FIELDS[key].include?(k.to_s) || next
          data[key][k] = v.to_s
        end
      end

      loop_detail = @client.patch("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/detail", data)[:data]
      loop_detail = Dotloop::LoopDetail.new(loop_detail).details
      Dotloop::Models::LoopDetail.new(loop_detail)
    end

    private

    def raise_if_invalid_batch_size(options)
      raise 'invalid batch size provided, allowed values minimum 1 and maximum 100' if !options[:batch_size].nil? && (options[:batch_size] < 1 || options[:batch_size] > 100)
    end

    def query_params(options)
      {
        batch_number:        batch_number(options),
        batch_size:          batch_size(options),
        sort:                options[:sort],
        filter:              options[:filter],
        include_details:     options[:include_details]
      }.delete_if { |_, v| should_delete(v) }
    end
  end
end
