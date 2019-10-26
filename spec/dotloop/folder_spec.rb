# frozen_string_literal: true

require 'spec_helper'

describe Dotloop::Folder do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject(:dotloop_folder) { Dotloop::Folder.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(dotloop_folder).to_not be_nil
    end

    it 'set the client' do
      expect(dotloop_folder.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of folders' do
      dotloop_mock(:folders)
      folders = dotloop_folder.all(profile_id: 1_234, loop_id: 76_046)
      expect(folders).not_to be_empty
      expect(folders).to all(be_a(Dotloop::Models::Folder))
      expect(folders.first).to have_attributes(name: 'Disclosures')
    end
  end

  describe '#find' do
    it 'return a folder' do
      dotloop_mock(:folder)
      folder = dotloop_folder.find(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424)
      expect(folder).to be_a(Dotloop::Models::Folder)
      expect(folder).to have_attributes(name: 'Disclosures')
    end
  end

  describe '#create' do
    it 'return a folder' do
      dotloop_mock(:folders, :post, 201)
      folder = dotloop_folder.create(profile_id: 1_234, loop_id: 76_046, params: { name: 'Disclosures' })
      expect(folder).to be_a(Dotloop::Models::Folder)
      expect(folder).to have_attributes(name: 'Disclosures')
    end
  end

  describe '#update' do
    it 'return a folder' do
      dotloop_mock(:folder, :patch)
      folder = dotloop_folder.update(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, params: { name: 'Disclosures' })
      expect(folder).to be_a(Dotloop::Models::Folder)
      expect(folder).to have_attributes(name: 'Disclosures')
    end
  end
end
