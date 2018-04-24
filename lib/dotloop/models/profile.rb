# frozen_string_literal: true

module Dotloop
  module Models
    class Profile
      include Virtus.model

      attribute :address
      attribute :city
      attribute :company
      attribute :deactivated, Boolean
      attribute :default, Boolean
      attribute :fax
      attribute :id, Integer
      attribute :name
      attribute :phone
      attribute :requires_template, Boolean
      attribute :state
      attribute :type
      attribute :zip_code

      attr_accessor :client

      def loops
        client.Loop.all(profile_id: id)
      end

      def create_loop(data)
        client.Loop.create(profile_id: id, params: data)
      end

      def loop_it(data)
        client.Loop.loop_it(profile_id: id, params: data)
      end
    end
  end
end
