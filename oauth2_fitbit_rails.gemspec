# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth2_fitbit_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "oauth2_fitbit_rails"
  spec.version       = Oauth2FitbitRails::VERSION
  spec.authors       = ["shreya"]
  spec.email         = ["shreya@appsimpact.com"]

  spec.summary       = "Oauth2 Rails based client for Fitbit specifically."
  spec.homepage      = "https://github.com/shreyai/oauth2_fitbit_rails"
  spec.license       = 'MIT'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\n").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'faraday', '~> 0.7', '>= 0.7.0'
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
