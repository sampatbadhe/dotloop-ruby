require 'spec_helper'

describe Dotloop::Participant do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject { Dotloop::Participant.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(subject).to_not be_nil
    end

    it 'set the client' do
      expect(subject.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of participants' do
      dotloop_mock(:participants)
      participants = subject.all(profile_id: 1_234, loop_id: 76_046)
      expect(participants).to_not be_empty
      expect(participants).to all(be_a(Dotloop::Models::Participant))
    end
  end

  describe '#find' do
    it 'return a participant' do
      dotloop_mock(:participant)
      participant = subject.find(profile_id: 1_234, loop_id: 76_046, participant_id: 2_355)
      expect(participant).to be_a(Dotloop::Models::Participant)
      expect(participant).to have_attributes(full_name: 'Brian Erwin')
    end
  end

  describe '#create' do
    it 'return a participant' do
      dotloop_mock(:participants, :post, 201)
      params = {
        "fullName": "Brian Erwin",
        "email": "brian@gmail.com",
        "role": "BUYER",
        "phone": "5558675309"
      }

      participant = subject.create(profile_id: 1_234, loop_id: 76_046, params: params)
      expect(participant).to be_a(Dotloop::Models::Participant)
      expect(participant).to have_attributes(full_name: 'Brian Erwin')
      expect(participant).to have_attributes(phone: '5558675309')
    end
  end

  describe '#update' do
    it 'return a participant' do
      dotloop_mock(:participant, :patch)
      participant = subject.update(profile_id: 1_234, loop_id: 76_046, participant_id: 2_355, params: { email: "brian@gmail.com" })
      expect(participant).to be_a(Dotloop::Models::Participant)
      expect(participant).to have_attributes(email: "brian@gmail.com")
    end
  end

  describe '#delete' do
    it 'deletes a participant' do
      dotloop_mock(:participant, :delete, 204)
      participant = subject.delete(profile_id: 1_234, loop_id: 76_046, participant_id: 2_355)
      expect(participant).to eq({})
    end
  end
end
