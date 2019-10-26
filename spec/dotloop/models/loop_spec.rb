# frozen_string_literal: true

require_relative '../../spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Dotloop::Models::Loop do
  let(:profile_id) { 1234 }
  let(:loop_id) { 76_046 }
  let(:detail_) { double }
  let(:tasklists_) { double }
  let(:folders_) { double }
  let(:participants_) { double }

  let(:client) do
    double(
      Loop: detail_,
      Tasklist: tasklists_,
      Folder: folders_,
      Participant: participants_
    )
  end

  subject(:dotloop_loop) do
    lp = Dotloop::Models::Loop.new(id: loop_id)
    lp.profile_id = profile_id
    lp.client = client
    lp
  end

  describe '#detail' do
    it 'returns the detail' do
      expect(detail_).to receive(:detail).with(profile_id: profile_id, loop_id: loop_id).and_return(:loop_details)
      expect(dotloop_loop.detail).to eq(:loop_details)
    end
  end

  describe '#folders' do
    it 'returns folders' do
      expect(folders_).to receive(:all).with(profile_id: profile_id, loop_id: loop_id).and_return(:folders)
      expect(dotloop_loop.folders).to eq(:folders)
    end
  end

  describe '#tasklists' do
    it 'returns tasklists' do
      expect(tasklists_).to receive(:all).with(profile_id: profile_id, loop_id: loop_id).and_return(:tasklists)
      expect(dotloop_loop.tasklists).to eq(:tasklists)
    end
  end

  describe '#participants' do
    it 'returns participants' do
      expect(participants_).to receive(:all).with(profile_id: profile_id, loop_id: loop_id).and_return(:participants)
      expect(dotloop_loop.participants).to eq(:participants)
    end
  end
end
