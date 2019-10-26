require 'spec_helper'

describe Dotloop::Template do
  let(:client) { Dotloop::Client.new(access_token: SecureRandom.uuid) }
  subject(:dotloop_template) { Dotloop::Template.new(client: client) }

  describe '#initialize' do
    it 'exist' do
      expect(dotloop_template).to_not be_nil
    end

    it 'set the client' do
      expect(dotloop_template.client).to eq(client)
    end
  end

  describe '#all' do
    it 'return a list of templates' do
      dotloop_mock(:loop_templates)
      templates = dotloop_template.all(profile_id: 1234)
      expect(templates).to_not be_empty
      expect(templates).to all(be_a(Dotloop::Models::Template))
      expect(templates.first.client).to eq(client)
    end
  end

  describe '#find' do
    it 'finds a single template by id' do
      dotloop_mock(:loop_template)
      template_data = dotloop_template.find(profile_id: 1234, loop_template_id: 421)
      expect(template_data).to be_a(Dotloop::Models::Template)
    end
  end
end
