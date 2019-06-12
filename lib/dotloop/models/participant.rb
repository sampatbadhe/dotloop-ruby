# frozen_string_literal: true

module Dotloop
  module Models
    class Participant
      include Virtus.model
      attribute :email
      attribute :full_name
      attribute :id, Integer
      attribute :role
      attribute :phone

      attr_accessor :client
      attr_accessor :profile_id
      attr_accessor :loop_id
    end
  end
end
