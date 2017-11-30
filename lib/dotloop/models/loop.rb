# frozen_string_literal: true

module Dotloop
  module Models
    class Loop
      include Virtus.model
      attribute :completed_task_count, Integer
      attribute :id, Integer
      attribute :name
      attribute :loop_url, Integer
      attribute :profile_id, Integer
      attribute :status
      attribute :transaction_type
      attribute :total_task_count, Integer
      attribute :updated, DateTime

      attr_accessor :client
      attr_accessor :profile_id

      def detail
        client.Loop.detail(profile_id: profile_id, loop_id: id)
      end

      def folders
        client.Folder.all(profile_id: profile_id, loop_id: id)
      end

      def participants
        client.Participant.all(profile_id: profile_id, loop_id: id)
      end

      def tasklists
        client.Tasklist.all(profile_id: profile_id, loop_id: id)
      end

      def update(data)
        client.Loop.update(profile_id: profile_id, loop_id: id, params: data)
      end

      def update_details(data)
        client.Loop.update_details(profile_id: profile_id, loop_id: id, params: data)
      end
    end
  end
end
