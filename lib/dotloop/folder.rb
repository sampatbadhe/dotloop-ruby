# frozen_string_literal: true

module Dotloop
  class Folder
    attr_accessor :client

    FOLDER_FIELDS = %w[name].freeze

    def initialize(client:)
      @client = client
    end

    def all(profile_id:, loop_id:)
      url = "/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/folder"
      @client.get(url)[:data].map do |folder_attrs|
        folder = Dotloop::Models::Folder.new(folder_attrs)
        folder.client = client
        folder.profile_id = profile_id.to_i
        folder.loop_id = loop_id.to_i
        folder
      end
    end

    def find(profile_id:, loop_id:, folder_id:)
      folder_data = @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/folder/#{folder_id.to_i}")[:data]
      folder = Dotloop::Models::Folder.new(folder_data)
      folder.client = client
      folder.profile_id = profile_id.to_i
      folder.loop_id = loop_id.to_i
      folder
    end

    def create(profile_id:, loop_id:, params: {})
      data = {
        name: params['name']
      }

      folder_data = @client.post("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/folder", data)[:data]
      folder = Dotloop::Models::Folder.new(folder_data)
      folder.client = client
      folder.profile_id = profile_id.to_i
      folder
    end

    def update(profile_id:, loop_id:, folder_id:, params: {})
      data = {}
      params.each do |key, value|
        FOLDER_FIELDS.include?(key.to_s) || next
        data[key] = value.to_s
      end

      folder_data = @client.patch("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/folder/#{folder_id.to_i}", data)[:data]
      folder = Dotloop::Models::Folder.new(folder_data)
      folder.client = client
      folder.profile_id = profile_id.to_i
      folder.loop_id = loop_id.to_i
      folder
    end
  end
end
