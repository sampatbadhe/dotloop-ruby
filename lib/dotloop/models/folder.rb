# frozen_string_literal: true

module Dotloop
  module Models
    class Folder
      include Virtus.model
      attribute :name
      attribute :id, Integer

      attr_accessor :client
      attr_accessor :profile_id
      attr_accessor :loop_id

      def documents
        client.Document.all(profile_id: profile_id, loop_id: loop_id, folder_id: id)
      end
    end
  end
end
