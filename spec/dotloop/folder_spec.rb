require 'spec_helper'

describe Dotloop::Folder do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject { Dotloop::Folder.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(subject).to_not be_nil
    end

    it 'set the client' do
      expect(subject.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of folders' do
      dotloop_mock(:folders)
      folders = subject.all(profile_id: 1_234, loop_id: 76_046)
      expect(folders).not_to be_empty
      expect(folders).to all(be_a(Dotloop::Models::Folder))
      expect(folders.first).to have_attributes(name: 'Disclosures')
    end
  end

  describe '#find' do
    it 'return a folder' do
      dotloop_mock(:folder)
      folder = subject.find(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424)
      expect(folder).to be_a(Dotloop::Models::Folder)
      expect(folder).to have_attributes(name: 'Disclosures')
    end
  end

  describe '#create' do
    it 'return a folder' do
      dotloop_mock(:folders, :post, 201)
      folder = subject.create(profile_id: 1_234, loop_id: 76_046, params: { name: 'Disclosures' })
      expect(folder).to be_a(Dotloop::Models::Folder)
      expect(folder).to have_attributes(name: 'Disclosures')
    end
  end

  describe '#update' do
    it 'return a folder' do
      dotloop_mock(:folder, :patch)
      folder = subject.update(profile_id: 1_234, loop_id: 76_046, folder_id: 423_424, params: { name: 'Disclosures' })
      expect(folder).to be_a(Dotloop::Models::Folder)
      expect(folder).to have_attributes(name: 'Disclosures')
    end
  end
end
