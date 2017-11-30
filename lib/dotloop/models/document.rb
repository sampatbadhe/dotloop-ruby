# frozen_string_literal: true

module Dotloop
  module Models
    class Document
      include Virtus.model
      attribute :created, DateTime
      attribute :id, Integer
      attribute :name
      attribute :updated, DateTime

      attr_accessor :client
      attr_accessor :profile_id
      attr_accessor :loop_id
      attr_accessor :folder_id

      def download
        client.Document.get(
          profile_id: profile_id,
          loop_id: loop_id,
          folder_id: folder_id,
          document_id: id
        )
      end
    end
  end
end
