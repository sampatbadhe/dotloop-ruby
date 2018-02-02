require 'spec_helper'

describe Dotloop::Document do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject { Dotloop::Document.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(subject).to_not be_nil
    end

    it 'set the client' do
      expect(subject.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of documents' do
      dotloop_mock(:documents)
      documents = subject.all(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424)
      expect(documents).not_to be_empty
      expect(documents).to all(be_a(Dotloop::Models::Document))
      expect(documents.first).to have_attributes(name: 'disclosures.pdf')
    end
  end

  describe '#find' do
    it 'return a document' do
      dotloop_mock(:document)
      document = subject.find(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, document_id: 561_621)
      expect(document).to be_a(Dotloop::Models::Document)
      expect(document).to have_attributes(name: 'disclosures.pdf')
    end
  end

  describe '#get' do
    it 'should get pdf data' do
      dotloop_pdf
      document = subject.get(profile_id: 1_234,
                             loop_id: 76_046,
                             folder_id: 423_424,
                             document_id: 561_621)
      expect(document.string).to eq(disclosure_file_data)
    end
  end

  describe '#upload' do
    it 'return a document' do
      file =  File.read("#{ROOT}/spec/stub_responses/get/profile/1234/loop/76046/folder/423424/document/561621/AgencyDisclosureStatementSeller.pdf")
      dotloop_mock(:document_upload, :post, 201)
      document = subject.upload(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, params: { "file_name" => 'AgencyDisclosureStatementSeller.pdf', "file_content" => file })
      expect(document).to be_a(Dotloop::Models::Document)
      expect(document).to have_attributes(name: 'AgencyDisclosureStatementSeller.pdf')
    end
  end
end
