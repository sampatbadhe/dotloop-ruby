# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class ContractInfo
        include Virtus.model
        attribute :transaction_number
        attribute :type
      end
    end
  end
end
