# frozen_string_literal: true

require 'spec_helper'

describe Dotloop::Document do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject(:dotloop_document) { Dotloop::Document.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(dotloop_document).to_not be_nil
    end

    it 'set the client' do
      expect(dotloop_document.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of documents' do
      dotloop_mock(:documents)
      documents = dotloop_document.all(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424)
      expect(documents).not_to be_empty
      expect(documents).to all(be_a(Dotloop::Models::Document))
      expect(documents.first).to have_attributes(name: 'disclosures.pdf')
    end
  end

  describe '#find' do
    it 'return a document' do
      dotloop_mock(:document)
      document = dotloop_document.find(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, document_id: 561_621)
      expect(document).to be_a(Dotloop::Models::Document)
      expect(document).to have_attributes(name: 'disclosures.pdf')
    end
  end

  describe '#get' do
    it 'should get pdf data' do
      dotloop_pdf
      document = dotloop_document.get(profile_id: 1_234,
                                      loop_id: 76_046,
                                      folder_id: 423_424,
                                      document_id: 561_621)
      expect(document.string).to eq(disclosure_file_data)
    end
  end

  describe '#upload' do
    it 'return a document' do
      file = File.read("#{ROOT}/spec/stub_responses/get/profile/1234/loop/76046/folder/423424/document/561621/AgencyDisclosureStatementSeller.pdf")
      dotloop_mock(:document_upload, :post, 201)
      document = dotloop_document.upload(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, params: { 'file_name' => 'AgencyDisclosureStatementSeller.pdf', 'file_content' => file })
      expect(document).to be_a(Dotloop::Models::Document)
      expect(document).to have_attributes(name: 'AgencyDisclosureStatementSeller.pdf')
    end

    it 'raise the error if file name is not provided' do
      file =  File.read("#{ROOT}/spec/stub_responses/get/profile/1234/loop/76046/folder/423424/document/561621/AgencyDisclosureStatementSeller.pdf")
      dotloop_mock(:document_upload, :post, 201)
      expect do
        dotloop_document.upload(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, params: { 'file_content' => file })
      end.to raise_error RuntimeError
    end

    it 'raise the error if file name is empty' do
      file =  File.read("#{ROOT}/spec/stub_responses/get/profile/1234/loop/76046/folder/423424/document/561621/AgencyDisclosureStatementSeller.pdf")
      dotloop_mock(:document_upload, :post, 201)
      expect do
        dotloop_document.upload(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, params: { 'file_name' => '', 'file_content' => file })
      end.to raise_error RuntimeError
    end

    it 'raise the error if file content is not provided' do
      dotloop_mock(:document_upload, :post, 201)
      expect do
        dotloop_document.upload(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, params: { 'file_name' => 'AgencyDisclosureStatementSeller.pdf' })
      end.to raise_error RuntimeError
    end

    it 'raise the error if file content is empty' do
      dotloop_mock(:document_upload, :post, 201)
      expect do
        dotloop_document.upload(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, params: { 'file_name' => 'AgencyDisclosureStatementSeller.pdf', 'file_content' => '' })
      end.to raise_error RuntimeError
    end
  end
end
