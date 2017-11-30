# frozen_string_literal: true

module Dotloop
  class Profile
    attr_accessor :client

    def initialize(client:)
      @client = client
    end

    def all
      @client.get('/profile')[:data].map do |profile_attrs|
        profile = Dotloop::Models::Profile.new(profile_attrs)
        profile.client = client
        profile
      end
    end

    def find(profile_id:)
      profile_attrs = @client.get("/profile/#{profile_id.to_i}")[:data]
      profile = Dotloop::Models::Profile.new(profile_attrs)
      profile.client = client
      profile
    end
  end
end
