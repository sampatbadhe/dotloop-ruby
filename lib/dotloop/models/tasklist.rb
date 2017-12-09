# frozen_string_literal: true

module Dotloop
  module Models
    class Tasklist
      include Virtus.model
      attribute :name
      attribute :id, Integer

      attr_accessor :profile_id
      attr_accessor :loop_id
      attr_accessor :client

      def tasks
        client.Task.all(
          profile_id: profile_id,
          loop_id: loop_id,
          task_list_id: id
        )
      end

      def get
        client.Tasklist.get(
          profile_id: profile_id,
          loop_id: loop_id,
          task_list_id: id
        )
      end
    end
  end
end
