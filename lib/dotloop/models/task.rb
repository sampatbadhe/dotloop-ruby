# frozen_string_literal: true

module Dotloop
  module Models
    class Task
      include Virtus.model
      attribute :name
      attribute :completed
      attribute :due
      attribute :id, Integer

      attr_accessor :client
      attr_accessor :profile_id
      attr_accessor :loop_id
      attr_accessor :tasklist_id
    end
  end
end
