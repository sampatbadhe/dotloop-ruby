require_relative '../../spec_helper'

RSpec.describe Dotloop::Models::Tasklist do
  let(:profile_id) { 1234 }
  let(:loop_id) { 76_046 }
  let(:tasklist_id) { 123 }
  let(:tasks_) { double }
  let(:client) { double(Task: tasks_) }
  subject do
    tasklist = Dotloop::Models::Tasklist.new(id: tasklist_id)
    tasklist.profile_id = profile_id
    tasklist.loop_id = loop_id
    tasklist.client = client
    tasklist
  end

  describe '#tasks' do
    it 'returns the profiles loops' do
      expect(tasks_).to receive(:all).with(profile_id: profile_id, loop_id: loop_id, tasklist_id:  tasklist_id).and_return(:blah)
      expect(subject.tasks).to eq(:blah)
    end
  end

  # describe '#employees' do
  #   it 'return the employees' do
  #     expect(employee_).to receive(:all).with(profile_id: 1234).and_return(:emps)
  #     expect(subject.employees).to eq(:emps)
  #   end
  # end
end
