# frozen_string_literal: true

module Dotloop
  module Models
    module LoopDetails
      class Financials
        include Virtus.model
        attribute :sale_commission_rate
        attribute :earnest_money_held_by
        attribute :purchase_sale_price
        attribute :earnest_money_amount
        attribute :sale_commission_total
        attribute :sale_commission_split_percent_buy_side
        attribute :sale_commission_split_percent_sell_side
        attribute :sale_commission_split_doller_buy_side
        attribute :sale_commission_split_doller_sell_side
      end
    end
  end
end
