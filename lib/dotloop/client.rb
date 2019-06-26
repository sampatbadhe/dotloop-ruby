# frozen_string_literal: true

module Dotloop
  class Client
    include HTTParty

    base_uri 'https://api-gateway.dotloop.com/public/v2/'

    DOTLOOP_FILE_UPLOAD_BOUNDARY = "AaB03x"

    attr_accessor :access_token
    attr_accessor :application

    def initialize(access_token:, application: 'dotloop')
      @access_token = access_token
      @application  = application
      raise 'Please enter an Access Token' unless @access_token
    end

    def delete(page)
      response = self.class.delete(page, headers: headers, timeout: 60)
      handle_dotloop_error(response) if response.code != 204
      self.class.snakify(response.parsed_response)
    end

    def get(page, params = {})
      response = self.class.get(page, query: params, headers: headers, timeout: 60)
      handle_dotloop_error(response) if response.code != 200
      self.class.snakify(response.parsed_response)
    end

    def post(page, params = {})
      response = self.class.post(page, body: params.to_json, headers: post_headers, timeout: 60)
      handle_dotloop_error(response) if response.code != 201
      self.class.snakify(response.parsed_response)
    end

    def patch(page, params = {})
      response = self.class.patch(page, body: params.to_json, headers: post_headers, timeout: 60)
      handle_dotloop_error(response) if response.code != 200
      self.class.snakify(response.parsed_response)
    end

    def download(page, params = {})
      response = self.class.get(page, query: params, headers: download_headers, timeout: 60)
      handle_dotloop_error(response) if response.code != 200
      response.parsed_response
    end

    def upload(page, body)
      response = self.class.post(page, body: body, headers: upload_headers, timeout: 600)
      handle_dotloop_error(response) if response.code != 201
      self.class.snakify(response.parsed_response)
    end

    def handle_dotloop_error(response)
      response_code = response.code
      error = case response_code
              when 400
                Dotloop::BadRequest
              when 401
                Dotloop::Unauthorized
              when 403
                Dotloop::Forbidden
              when 404
                Dotloop::NotFound
              when 422
                Dotloop::UnprocessableEntity
              when 429
                Dotloop::TooManyRequest
              else
                StandardError
              end
      raise error, "Error communicating: Response code #{response_code}"
    end

    def account
      get('/account', {})
    end

    def Document
      @document ||= Dotloop::Document.new(client: self)
    end

    def Folder
      @folder ||= Dotloop::Folder.new(client: self)
    end

    def Profile
      @profile ||= Dotloop::Profile.new(client: self)
    end

    def Loop
      @loop ||= Dotloop::Loop.new(client: self)
    end

    def Participant
      @participant ||= Dotloop::Participant.new(client: self)
    end

    def Tasklist
      @tasklist ||= Dotloop::Tasklist.new(client: self)
    end

    def Task
      @task ||= Dotloop::Task.new(client: self)
    end

    def Template
      @template ||= Dotloop::Template.new(client: self)
    end

    def Contact
      @person ||= Dotloop::Contact.new(client: self)
    end

    def self.snakify(hash)
      if hash.is_a? Array
        hash.map{ |item| symbolize(item.to_snake_keys) }
      else
        symbolize(hash.to_snake_keys)
      end
    end

    private

    def self.symbolize(obj)
      return obj.reduce({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = symbolize(v) }
      end if obj.is_a? Hash
      return obj.reduce([]) do |memo, v|
        memo << symbolize(v); memo
      end if obj.is_a? Array
      obj
    end

    def download_headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'User-Agent' => @application,
        'Accept' => 'application/pdf'
      }
    end

    def upload_headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'User-Agent' => @application,
        'Content-Type' => "multipart/form-data\; boundary=#{DOTLOOP_FILE_UPLOAD_BOUNDARY}"
      }
    end

    def headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'User-Agent' => @application,
        'Accept' => '*/*'
      }
    end

    def post_headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'User-Agent' => @application,
        'Accept' => '*/*',
        'Content-Type' => 'application/json'
      }
    end
  end
end
