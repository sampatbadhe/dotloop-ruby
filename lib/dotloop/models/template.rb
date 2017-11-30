# frozen_string_literal: true

module Dotloop
  module Models
    class Template
      include Virtus.model
      attribute :name
      attribute :id, Integer
      attribute :profile_id, Integer
      attribute :transaction_type
      attribute :shared, Boolean
      attribute :global, Boolean

      attr_accessor :profile_id
      attr_accessor :client
    end
  end
end
