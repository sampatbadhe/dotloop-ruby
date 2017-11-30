require 'spec_helper'

describe Dotloop::Profile do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject { Dotloop::Profile.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(subject).to_not be_nil
    end

    it 'set the client' do
      expect(subject.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of profiles' do
      dotloop_mock(:profiles)
      profiles = subject.all
      expect(profiles).to_not be_empty
      expect(profiles).to all(be_a(Dotloop::Models::Profile))
      expect(profiles.first.client).to eq(client)
    end
  end

  describe '#find' do
    it 'finds a single profile by id' do
      dotloop_mock(:profile)
      profile_data = subject.find(profile_id: 1234)
      expect(profile_data).to be_a(Dotloop::Models::Profile)
    end
  end
end
