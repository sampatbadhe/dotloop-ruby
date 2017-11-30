# frozen_string_literal: true

module Dotloop
  class Task
    attr_accessor :client

    def initialize(client:)
      @client = client
    end

    def all(profile_id:, loop_id:, tasklist_id:)
      @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/tasklist/#{tasklist_id.to_i}/task")[:data].map do |task_attrs|
        task = Dotloop::Models::Task.new(task_attrs)
        task.client = client
        task.profile_id = profile_id.to_i
        task.loop_id = loop_id.to_i
        task.tasklist_id = tasklist_id.to_i
        task
      end
    end

    def find(profile_id:, loop_id:, tasklist_id:, task_id:)
      task_data = @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/tasklist/#{tasklist_id.to_i}/task/#{task_id.to_i}")[:data]
      task = Dotloop::Models::Task.new(task_data)
      task.client = client
      task.profile_id = profile_id.to_i
      task.loop_id = loop_id.to_i
      task.tasklist_id = tasklist_id.to_i
      task
    end
  end
end
