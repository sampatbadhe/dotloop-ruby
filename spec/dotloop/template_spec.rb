require 'spec_helper'

describe Dotloop::Template do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject { Dotloop::Template.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(subject).to_not be_nil
    end

    it 'set the client' do
      expect(subject.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of templates' do
      dotloop_mock(:loop_templates)
      templates = subject.all(profile_id: 1234)
      expect(templates).to_not be_empty
      expect(templates).to all(be_a(Dotloop::Models::Template))
      expect(templates.first.client).to eq(client)
    end
  end

  describe '#find' do
    it 'finds a single template by id' do
      dotloop_mock(:loop_template)
      template_data = subject.find(profile_id: 1234, loop_template_id: 421)
      expect(template_data).to be_a(Dotloop::Models::Template)
    end
  end
end
