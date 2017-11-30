# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class ContractDates
        include Virtus.model
        attribute :contract_agreement_date
        attribute :closing_date
      end
    end
  end
end
