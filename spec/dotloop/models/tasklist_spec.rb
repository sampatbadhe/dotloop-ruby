# frozen_string_literal: true

require_relative '../../spec_helper'

RSpec.describe Dotloop::Models::Tasklist do
  let(:profile_id) { 1234 }
  let(:loop_id) { 76_046 }
  let(:task_list_id) { 123 }
  let(:tasks_) { double }
  let(:client) { double(Task: tasks_) }
  subject(:dotloop_tasklist) do
    tasklist = Dotloop::Models::Tasklist.new(id: task_list_id)
    tasklist.profile_id = profile_id
    tasklist.loop_id = loop_id
    tasklist.client = client
    tasklist
  end

  describe '#tasks' do
    it 'returns the profiles loops' do
      expect(tasks_).to receive(:all).with(profile_id: profile_id, loop_id: loop_id, task_list_id: task_list_id).and_return(:blah)
      expect(dotloop_tasklist.tasks).to eq(:blah)
    end
  end
end
