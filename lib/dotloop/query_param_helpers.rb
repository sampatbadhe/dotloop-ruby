# frozen_string_literal: true

module Dotloop
  module QueryParamHelpers
    BATCH_SIZE = 50
    MAX_LOOPS = 500
    MAX_CONTACTS = 500

    private

    def query_params(options)
      {
        batch_number: batch_number(options),
        batch_size: batch_size(options)
      }.delete_if { |_, v| should_delete(v) }
    end

    def should_delete(value)
      value.nil? || (value.is_a?(Integer) && value.zero?) || (value.is_a?(String) && value.size.zero?)
    end

    def profile_id(options)
      raise 'profile_id is required' unless options[:profile_id]
      options[:profile_id].to_i
    end

    def batch_number(options)
      options[:batch_number].to_i
    end

    def batch_size(options)
      size = options[:batch_size].to_i
      size.between?(1, BATCH_SIZE) ? size : BATCH_SIZE
    end
  end
end
