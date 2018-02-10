# frozen_string_literal: true

module Dotloop
  class Document
    DOTLOOP_FILE_UPLOAD_BOUNDARY = "AaB03x"

    attr_accessor :client

    def initialize(client:)
      @client = client
    end

    def all(profile_id:, loop_id:, folder_id:)
      @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/folder/#{folder_id.to_i}/document")[:data].map do |document_attrs|
        doc = Dotloop::Models::Document.new(document_attrs)
        doc.client = client
        doc.profile_id = profile_id.to_i
        doc.loop_id = loop_id.to_i
        doc.folder_id = folder_id.to_i
        doc
      end
    end

    def find(profile_id:, loop_id:, folder_id:, document_id:)
      document_data = @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/folder/#{folder_id.to_i}/document/#{document_id.to_i}")[:data]
      document = Dotloop::Models::Document.new(document_data)
      document.client = client
      document.profile_id = profile_id.to_i
      document.loop_id = loop_id.to_i
      document.folder_id = folder_id.to_i
      document
    end

    def get(profile_id:, loop_id:, folder_id:, document_id:)
      sio = StringIO.new
      sio.set_encoding(Encoding::ASCII_8BIT)
      sio.write(
        @client.download(
          "/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/folder/#{folder_id.to_i}/document/#{document_id.to_i}"
        )
      )
      sio.flush
      sio.close
      sio
    end

    def upload(profile_id:, loop_id:, folder_id:, params: {})
      file_name = params["file_name"]
      file_content = params["file_content"]
      raise 'Please pass file name' if (file_name.nil? || file_name.empty?)
      raise 'Please pass file content' if (file_content.nil? || file_content.empty?)
      post_body = []

      post_body << "--#{DOTLOOP_FILE_UPLOAD_BOUNDARY}\r\n"
      post_body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{file_name}\"\r\n"
      post_body << "Content-Type: application/pdf\r\n"
      post_body << "\r\n"
      post_body << file_content
      post_body << "\r\n--#{DOTLOOP_FILE_UPLOAD_BOUNDARY}--\r\n"

      document_data = @client.upload("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/folder/#{folder_id.to_i}/document/", post_body.join)[:data]
      document = Dotloop::Models::Document.new(document_data)
      document.client = client
      document.profile_id = profile_id.to_i
      document.loop_id = loop_id.to_i
      document.folder_id = folder_id.to_i
      document
    end
  end
end
