require 'spec_helper'

describe Dotloop::Loop do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject { Dotloop::Loop.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(subject).to_not be_nil
    end

    it 'have a client' do
      expect(subject.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return all loops' do
      dotloop_mock_batch(:loops)
      expect(subject).to receive(:batch).twice.and_call_original
      loops = subject.all(profile_id: '1234')
      expect(loops.size).to eq(52)
      expect(loops).to all(be_a(Dotloop::Models::Loop))
    end
  end

  describe '#find' do
    it 'finds a single loop by id' do
      dotloop_mock(:loop)
      loop_data = subject.find(profile_id: 1234, loop_id: 76_046)
      expect(loop_data).to be_a(Dotloop::Models::Loop)
    end
  end

  describe '#detail' do
    it 'finds a single loop detail by id' do
      dotloop_mock(:loop_detail)
      loop_detail = subject.detail(profile_id: 1234, loop_id: 76_046)
      expect(loop_detail).to be_a(Dotloop::Models::LoopDetail)
      expect(loop_detail.loop_id).to eq 76_046
      expect(loop_detail.contract_dates).to be_a(Dotloop::Models::LoopDetails::ContractDates)
      expect(loop_detail.contract_info).to be_a(Dotloop::Models::LoopDetails::ContractInfo)
      expect(loop_detail.financials).to be_a(Dotloop::Models::LoopDetails::Financials)
      expect(loop_detail.geographic_description).to be_a(Dotloop::Models::LoopDetails::GeographicDescription)
      expect(loop_detail.listing_information).to be_a(Dotloop::Models::LoopDetails::ListingInformation)
      expect(loop_detail.offer_dates).to be_a(Dotloop::Models::LoopDetails::OfferDates)
      expect(loop_detail.property).to be_a(Dotloop::Models::LoopDetails::Property)
      expect(loop_detail.property_address).to be_a(Dotloop::Models::LoopDetails::PropertyAddress)
      expect(loop_detail.referral).to be_a(Dotloop::Models::LoopDetails::Referral)
      expect(loop_detail.contacts).to all(be_a(Dotloop::Models::LoopDetails::Contact))
    end
  end

  describe '#create' do
    it 'creates a loop' do
      dotloop_mock(:loops, :post, 201)
      doltoop_loop = subject.create(profile_id: 1_234, params: { name: 'Atturo Garay, 3059 Main, Chicago, IL 60614', status: "ARCHIVED", transactionType: "PURCHASE_OFFER" })
      expect(doltoop_loop).to be_a(Dotloop::Models::Loop)
      expect(doltoop_loop).to have_attributes({ name: 'Atturo Garay, 3059 Main, Chicago, IL 60614', status: "ARCHIVED", transaction_type: "PURCHASE_OFFER", id: 34308 })
    end
  end

  describe '#update' do
    it 'updates a loop' do
      dotloop_mock(:loop, :patch)
      doltoop_loop = subject.update(profile_id: 1_234, loop_id: 76_046, params: { name: 'Disclosures' })
      expect(doltoop_loop).to be_a(Dotloop::Models::Loop)
      expect(doltoop_loop).to have_attributes(name: 'Atturo Garay, 3059 Main, Chicago, IL 60614')
    end
  end

  describe '#loop-it' do
    it 'create a loop' do
      dotloop_mock(:loop_it, :post, 201, "?profile_id=1234")
      params = {
        "name": "Brian Erwin",
        "transactionType": "PURCHASE_OFFER",
        "status": "PRE_OFFER",
        "streetName": "Waterview Dr",
        "streetNumber": "2100",
        "unit": "12",
        "city": "San Francisco",
        "zipCode": "94114",
        "state": "CA",
        "country": "US",
        "participants": [
          {
            "fullName": "Brian Erwin",
            "email": "brianerwin@newkyhome.com",
            "role": "BUYER"
          }
        ],
        "templateId": 1424,
        "mlsPropertyId": "43FSB8",
        "mlsId": "789",
        "mlsAgentId": "123456789"
      }

      doltoop_loop = subject.loop_it(profile_id: 1_234, params: params)
      expect(doltoop_loop).to be_a(Dotloop::Models::Loop)
      expect(doltoop_loop).to have_attributes({ name: 'Brian Erwin', status: "PRE_OFFER", transaction_type: "PURCHASE_OFFER", id: 76046 })
    end
  end

  describe '#update_details' do
    it 'updates a loop details' do
      dotloop_mock(:loop_detail, :patch)
      params = {
        "Property Address" => {
          "Street Name": "Waterview Dr",
          "Street Number": "2100",
          "Unit Number": "12",
          "City": "San Francisco",
          "Zip/Postal Code": "94114",
          "State/Prov": "CA",
          "Country": "US"
        }
      }

      doltoop_loop = subject.update_details(profile_id: 1_234, loop_id: 76_046, params: params)
      expect(doltoop_loop).to be_a(Dotloop::Models::LoopDetail)
    end
  end
end
