# frozen_string_literal: true

module Dotloop
  module Models
    class Account
      include Virtus.model
      attribute :email
      attribute :first_name
      attribute :id, Integer
      attribute :last_name
      attribute :default_profile_id
      attr_accessor :client
    end
  end
end
