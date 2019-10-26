require 'spec_helper'

describe Dotloop::Task do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject(:dotloop_task) { Dotloop::Task.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(dotloop_task).to_not be_nil
    end

    it 'set the client' do
      expect(dotloop_task.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of tasks' do
      dotloop_mock(:tasks)
      tasks = dotloop_task.all(profile_id: 1_234, loop_id: 76_046, task_list_id: 123)
      expect(tasks).not_to be_empty
      expect(tasks).to all(be_a(Dotloop::Models::Task))
      expect(tasks.first).to have_attributes(name: 'contract')
    end
  end

  describe '#find' do
    it 'return a task' do
      dotloop_mock(:task)
      task = dotloop_task.find(profile_id: 1_234, loop_id: 76_046, task_list_id: 123, task_id: 125736485)
      expect(task).to be_a(Dotloop::Models::Task)
      expect(task).to have_attributes(name: 'contract')
    end
  end
end
