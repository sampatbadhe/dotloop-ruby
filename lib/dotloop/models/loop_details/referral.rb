# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class Referral
        include Virtus.model
        attribute :referral_source
        attribute :referral_percent
      end
    end
  end
end
