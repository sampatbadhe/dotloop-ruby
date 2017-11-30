# frozen_string_literal: true

module Dotloop
  class Template
    attr_accessor :client

    def initialize(client:)
      @client = client
    end

    def all(profile_id:)
      @client.get("/profile/#{profile_id.to_i}/loop-template")[:data].map do |template_attrs|
        template = Dotloop::Models::Template.new(template_attrs)
        template.client = client
        template.profile_id = profile_id.to_i
        template
      end
    end

    def find(profile_id:, loop_template_id:)
      template_data = @client.get("/profile/#{profile_id.to_i}/loop-template/#{loop_template_id.to_i}")[:data]
      template = Dotloop::Models::Template.new(template_data)
      template.client = client
      template.profile_id = profile_id.to_i
      template
    end
  end
end
