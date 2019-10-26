# frozen_string_literal: true

require 'spec_helper'

describe Dotloop::Participant do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject(:dotloop_participant) { Dotloop::Participant.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(dotloop_participant).to_not be_nil
    end

    it 'set the client' do
      expect(dotloop_participant.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of participants' do
      dotloop_mock(:participants)
      participants = dotloop_participant.all(profile_id: 1_234, loop_id: 76_046)
      expect(participants).to_not be_empty
      expect(participants).to all(be_a(Dotloop::Models::Participant))
    end
  end

  describe '#find' do
    it 'return a participant' do
      dotloop_mock(:participant)
      participant = dotloop_participant.find(profile_id: 1_234, loop_id: 76_046, participant_id: 2_355)
      expect(participant).to be_a(Dotloop::Models::Participant)
      expect(participant).to have_attributes(full_name: 'Brian Erwin')
    end
  end

  describe '#create' do
    it 'return a participant' do
      dotloop_mock(:participants, :post, 201)
      params = {
        "fullName": 'Brian Erwin',
        "email": 'brianerwin@newkyhome.com',
        "role": 'BUYER',
        "Company Name": "Buyer's Company",
        "Street Name": 'Main street',
        "Street Number": '123',
        "Unit Number": '2',
        "Zip/Postal Code": '45123',
        "Country": 'USA',
        "City": 'Cincinnati',
        "State/Prov": 'OH',
        "Phone": '(555) 555-5555',
        "Cell Phone": '(555) 555-4444'
      }

      participant = dotloop_participant.create(profile_id: 1_234, loop_id: 76_046, params: params)
      expect(participant).to be_a(Dotloop::Models::Participant)
      expect(participant).to have_attributes(full_name: 'Brian Erwin')
      expect(participant).to have_attributes(email: 'brianerwin@newkyhome.com')
      expect(participant).to have_attributes(role: 'BUYER')
      expect(participant).to have_attributes(street_name: 'Main street')
      expect(participant).to have_attributes(street_number: '123')
      expect(participant).to have_attributes(city: 'Cincinnati')
      expect(participant).to have_attributes(state_prov: 'OH')
      expect(participant).to have_attributes(zip_postal_code: '45123')
      expect(participant).to have_attributes(unit_number: '2')
      expect(participant).to have_attributes(country: 'USA')
      expect(participant).to have_attributes(phone: '(555) 555-5555')
      expect(participant).to have_attributes(cell_phone: '(555) 555-4444')
      expect(participant).to have_attributes(company_name: "Buyer's Company")
    end
  end

  describe '#update' do
    it 'return a participant' do
      dotloop_mock(:participant, :patch)
      participant = dotloop_participant.update(profile_id: 1_234, loop_id: 76_046, participant_id: 2_355, params: { email: 'brian@gmail.com' })
      expect(participant).to be_a(Dotloop::Models::Participant)
      expect(participant).to have_attributes(email: 'brian@gmail.com')
    end
  end

  describe '#delete' do
    it 'deletes a participant' do
      dotloop_mock(:participant, :delete, 204)
      participant = dotloop_participant.delete(profile_id: 1_234, loop_id: 76_046, participant_id: 2_355)
      expect(participant).to eq({})
    end
  end
end
