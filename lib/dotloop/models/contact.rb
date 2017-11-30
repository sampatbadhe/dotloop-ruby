# frozen_string_literal: true

module Dotloop
  module Models
    class Contact
      include Virtus.model
      attribute :address
      attribute :city
      attribute :country
      attribute :email
      attribute :fax
      attribute :first_name
      attribute :home
      attribute :id, Integer
      attribute :last_name
      attribute :office
      attribute :state
      attribute :zip_code
      attr_accessor :client
    end
  end
end
