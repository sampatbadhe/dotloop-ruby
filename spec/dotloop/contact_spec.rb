# frozen_string_literal: true

require 'spec_helper'

describe Dotloop::Contact do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject(:dotloop_contact) { Dotloop::Contact.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(dotloop_contact).to_not be_nil
    end

    it 'set the client' do
      expect(dotloop_contact.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return all contacts' do
      dotloop_mock_batch(:contacts)
      contacts = dotloop_contact.all
      expect(contacts.size).to eq(52)
      expect(contacts).to all(be_a(Dotloop::Models::Contact))
    end
  end

  describe '#find' do
    it 'return a contact' do
      dotloop_mock(:contact)
      contact = dotloop_contact.find(contact_id: 3_603_862)
      expect(contact).to be_a(Dotloop::Models::Contact)
    end
  end

  describe '#create' do
    it 'return a contact' do
      dotloop_mock(:contacts, :post, 201)
      params = {
        "firstName": 'Brian',
        "lastName": 'Erwin',
        "email": 'brianerwin@newkyhome.com',
        "home": '(415) 8936 332',
        "office": '(415) 1213 656',
        "fax": '(415) 8655 686',
        "address": '2100 Waterview Dr',
        "city": 'San Francisco',
        "zipCode": '94114',
        "state": 'CA',
        "country": 'US'
      }

      contact = subject.create(params: params)
      expect(contact).to be_a(Dotloop::Models::Contact)
    end
  end

  describe '#update' do
    it 'return a contact' do
      dotloop_mock(:contact, :patch)
      contact = subject.update(contact_id: 3_603_862, params: { "home": '(415) 888 8888' })
      expect(contact).to be_a(Dotloop::Models::Contact)
      expect(contact).to have_attributes(home: '(415) 888 8888')
    end
  end

  describe '#delete' do
    it 'deletes a contact' do
      dotloop_mock(:contact, :delete, 204)
      contact = subject.delete(contact_id: 3_603_862)
      expect(contact).to eq({})
    end
  end
end
