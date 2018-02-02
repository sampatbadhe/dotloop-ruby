# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dotloop/version'

Gem::Specification.new do |spec|
  spec.name          = "dotloop-ruby"
  spec.version       = Dotloop::VERSION
  spec.authors       = ["sampatbadhe"]
  spec.email         = ["sampat.badhe@kiprosh.com"]

  spec.summary       = %(Dotloop library)
  spec.description   = %(dotloop-ruby is Ruby library for Dotloop API v2.)
  spec.homepage      = "https://github.com/sampatbadhe/dotloop-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'simplecov'
  spec.add_runtime_dependency 'coveralls'
  spec.add_runtime_dependency 'httparty', '~> 0.13'
  spec.add_runtime_dependency 'virtus', '~> 1.0'
  spec.add_runtime_dependency 'plissken', '~> 0.2'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'travis', '~> 1.8'
end
