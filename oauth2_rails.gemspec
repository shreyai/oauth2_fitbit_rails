# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth2_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "oauth2_rails"
  spec.version       = Oauth2Rails::VERSION
  spec.authors       = ["Colin Walker"]
  spec.email         = ["cjwalker@sfu.ca"]

  spec.summary       = %q{Oauth2 Rails based client for Fitbit specifically.}
  spec.homepage      = "https://github.com/ColDog/oauth2-fitbit-rails"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 0.7.0"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
