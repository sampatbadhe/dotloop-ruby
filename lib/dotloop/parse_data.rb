# frozen_string_literal: true

module Dotloop
  module ParseData
    def parse_data(data)
      fix_hash_keys(data).each { |item| build_section(item[0], item[1]) }
    end

    private

    def build_section(key, section_data)
      return unless fields.include?(key)
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
