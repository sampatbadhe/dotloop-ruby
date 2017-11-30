require 'spec_helper'

describe Dotloop::Client do
  let(:access_token) { 'blah' }
  let(:application) { 'bloh' }
  subject { Dotloop::Client.new(access_token: access_token, application: application) }

  describe '#initialize' do
    it 'take an access token' do
      expect(subject).to be_a(Dotloop::Client)
      expect(subject.access_token).to eq('blah')
    end

    context 'without application' do
      subject { Dotloop::Client.new(access_token: access_token) }

      it 'default the application name to dotloop' do
        expect(subject.application).to eq('dotloop')
      end
    end

    it 'take an application name' do
      expect(subject.application).to eq('bloh')
    end

    context 'without an api key' do
      let(:access_token) { nil }
      it 'raise the error' do
        expect { subject }.to raise_error RuntimeError
      end
    end
  end

  describe '#get' do
    let(:parsed_response) { { blahBlog: 42 } }
    let(:code) { 200 }
    let(:response) { double(code: code, parsed_response: parsed_response) }
    let(:headers) do
      {
        'Authorization' => "Bearer #{access_token}",
        'User-Agent' => application,
        'Accept' => '*/*'
      }
    end

    it 'call HTTParty get with the correct params' do
      expect(subject.class).to receive(:get)
        .with('foo', query: { bar: 2 }, headers: headers, timeout: 60).and_return(response)
      subject.get('foo', bar: 2)
    end

    context 'when there is an error' do
      let(:code) { 234 }
      it 'raise an error if the response code is not 200' do
        expect(subject.class).to receive(:get).with('foo', anything).and_return(response)
        expect { subject.get('foo') }.to raise_error StandardError
      end
    end

    context 'when there is a 401 error' do
      let(:code) { 401 }
      it 'raise an Unauthorized error' do
        expect(subject.class).to receive(:get).with('foo', anything).and_return(response)
        expect { subject.get('foo') }.to raise_error Dotloop::Unauthorized
      end
    end

    context 'when there is a 403 error' do
      let(:code) { 403 }
      it 'raise an Forbidden error' do
        expect(subject.class).to receive(:get).with('foo', anything).and_return(response)
        expect { subject.get('foo') }.to raise_error Dotloop::Forbidden
      end
    end

    context 'when the response is a single object' do
      it 'snake the camels' do
        expect(subject.class).to receive(:get).and_return(response)
        expect(subject.get('foo', bar: 15)).to eq(blah_blog: 42)
      end
    end

    context 'when the response is an array' do
      let(:parsed_response) do
        [
          { fooBar: 10 },
          { snakeFace: 22 }
        ]
      end
      it 'snake all the camels' do
        expect(subject.class).to receive(:get).and_return(response)
        expect(subject.get('foo', bar: 15)).to eq(
          [
            { foo_bar: 10 },
            { snake_face: 22 }
          ]
        )
      end
    end
  end

  describe '#Contact' do
    it 'return a Contact object' do
      expect(subject.Contact).to be_a(Dotloop::Contact)
    end
  end

  describe '#Document' do
    it 'return a Document object' do
      expect(subject.Document).to be_a(Dotloop::Document)
    end
  end

  describe '#Folder' do
    it 'return a Folder object' do
      expect(subject.Folder).to be_a(Dotloop::Folder)
    end
  end

  describe '#Loop' do
    it 'return a Loop object' do
      expect(subject.Loop).to be_a(Dotloop::Loop)
    end
  end

  describe '#Participant' do
    it 'return a Participant object' do
      expect(subject.Participant).to be_a(Dotloop::Participant)
    end
  end

  describe '#Profile' do
    it 'return a Profile object' do
      expect(subject.Profile).to be_a(Dotloop::Profile)
    end
  end

  describe '#Task' do
    it 'return a Task object' do
      expect(subject.Task).to be_a(Dotloop::Task)
    end
  end

  describe '#Tasklist' do
    it 'return a Tasklist object' do
      expect(subject.Tasklist).to be_a(Dotloop::Tasklist)
    end
  end

  describe '#Template' do
    it 'return a Template object' do
      expect(subject.Template).to be_a(Dotloop::Template)
    end
  end
end
