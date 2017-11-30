# frozen_string_literal: true

module Dotloop
  class Tasklist
    attr_accessor :client

    def initialize(client:)
      @client = client
    end

    def all(profile_id:, loop_id:)
      @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/tasklist")[:data].map do |tasklist_attrs|
        tasklist = Dotloop::Models::Tasklist.new(tasklist_attrs)
        tasklist.client = client
        tasklist.profile_id = profile_id.to_i
        tasklist.loop_id = loop_id.to_i
        tasklist
      end
    end

    def find(profile_id:, loop_id:, task_list_id:)
      tasklist_data = @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/tasklist/#{task_list_id.to_i}")[:data]
      tasklist = Dotloop::Models::Tasklist.new(tasklist_data)
      tasklist.client = client
      tasklist.profile_id = profile_id.to_i
      tasklist.loop_id = loop_id.to_i
      tasklist
    end
  end
end
