# frozen_string_literal: true

module Dotloop
  class Authenticate
    include HTTParty

    base_uri 'https://auth.dotloop.com/oauth/'

    attr_accessor :app_id
    attr_accessor :app_secret
    attr_accessor :application

    def initialize(app_id:, app_secret:, application: 'dotloop')
      @app_id      = app_id
      @app_secret  = app_secret
      @application = application
      raise 'Please enter an APP id' unless @app_id
      raise 'Please enter an APP secret' unless @app_secret
    end

    def acquire_access_and_refresh_token(code, options = {})
      params = {
        grant_type:   'authorization_code',
        code:         code,
        redirect_uri: options[:redirect_uri]
      }

      raw('/token', params)
    end

    def refresh_access_token(refresh_token)
      params = {
        grant_type:    'refresh_token',
        refresh_token: refresh_token
      }

      raw('/token', params)
    end

    def revoke_access(access_token)
      params = {
        token: access_token
      }

      raw('/token/revoke', params)
    end

    def raw(page, params = {})
      response = self.class.post(page, query: params, headers: headers, timeout: 60)
      handle_dotloop_error(response.code) if response.code != 200
      response.parsed_response
    end

    def handle_dotloop_error(response_code)
      error = case response_code
              when 400
                Dotloop::BadRequest
              when 401
                Dotloop::Unauthorized
              when 403
                Dotloop::Forbidden
              else
                StandardError
              end
      raise error, "Error communicating: Response code #{response_code}"
    end

    def url_for_authentication(redirect_uri, options = {})
      params = {
        client_id:     @app_id,
        response_type: 'code',
        redirect_uri:  redirect_uri
      }

      options.key?(:state) && params[:state] = options[:state]
      options.key?(:redirect_on_deny) && params[:redirect_on_deny] = options[:redirect_on_deny]

      "https://auth.dotloop.com/oauth/authorize?#{params.to_query}"
    end

    private

    def headers
      encode = Base64.encode64("#{app_id}:#{app_secret}").gsub(/\n/, '')
      {
        'Authorization' => "Basic #{encode}",
        'User-Agent'    => @application,
        'Accept'        => '*/*'
      }
    end
  end
end
