# frozen_string_literal: true

require 'simplecov'
require 'coveralls'
SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
SimpleCov.start
require 'bundler/setup'
Bundler.setup

require 'plissken'
require 'pry'
require 'webmock/rspec'
require_relative './helpers/webmocks'

ROOT = Pathname.new(Gem::Specification.find_by_name('dotloop-ruby').gem_dir).freeze
require 'dotloop-ruby'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |conf|
  conf.include Helpers

  conf.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end
