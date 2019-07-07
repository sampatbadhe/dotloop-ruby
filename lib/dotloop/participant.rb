# frozen_string_literal: true

module Dotloop
  class Participant
    include Dotloop::ParseData
    attr_accessor :client

    PARTICIPANT_FIELDS = [
      'fullName',
      'email',
      'role',
      'Street Name',
      'Street Number',
      'City',
      'State/Prov',
      'Zip/Postal Code',
      'Unit Number',
      'Country',
      'Phone',
      'Cell Phone',
      'Company Name'
    ].freeze

    def initialize(client:)
      @client = client
    end

    def all(profile_id:, loop_id:)
      @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/participant")[:data].map do |participant_attrs|
        participant_data = parse_data(participant_attrs)
        participant = Dotloop::Models::Participant.new(participant_attrs)
        participant.client = client
        participant.profile_id = profile_id.to_i
        participant.loop_id = loop_id.to_i
        participant
      end
    end

    def find(profile_id:, loop_id:, participant_id:)
      participant_data = @client.get("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/participant/#{participant_id.to_i}")[:data]
      participant_data = parse_data(participant_data)
      participant = Dotloop::Models::Participant.new(participant_data)
      participant.client = client
      participant.profile_id = profile_id.to_i
      participant.loop_id = loop_id.to_i
      participant
    end

    def create(profile_id:, loop_id:, params: {})
      data = {}
      params.each do |key, value|
        PARTICIPANT_FIELDS.include?(key.to_s) || next
        data[key] = value.to_s
      end
      participant_data = @client.post("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/participant", data)[:data]
      participant_data = parse_data(participant_data)
      participant = Dotloop::Models::Participant.new(participant_data)
      participant.client = client
      participant.profile_id = profile_id.to_i
      participant.loop_id = loop_id.to_i
      participant
    end

    def update(profile_id:, loop_id:, participant_id:, params: {})
      data = {}
      params.each do |key, value|
        PARTICIPANT_FIELDS.include?(key.to_s) || next
        data[key] = value.to_s
      end
      participant_data = @client.patch("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/participant/#{participant_id.to_i}", data)[:data]
      participant_data = parse_data(participant_data)
      participant = Dotloop::Models::Participant.new(participant_data)
      participant.client = client
      participant.profile_id = profile_id.to_i
      participant.loop_id = loop_id.to_i
      participant
    end

    def delete(profile_id:, loop_id:, participant_id:)
      @client.delete("/profile/#{profile_id.to_i}/loop/#{loop_id.to_i}/participant/#{participant_id.to_i}")
    end

    private

    def fields
      PARTICIPANT_FIELDS
    end
  end
end
