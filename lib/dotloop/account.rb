# frozen_string_literal: true

module Dotloop
  class Account
    attr_accessor :client

    def initialize(client:)
      @client = client
    end

    def find
      account_data = @client.get('/account')[:data]
      account = Dotloop::Models::Account.new(account_data)
      account.client = client
      account
    end
  end
end
