# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hanami/model/version"

Gem::Specification.new do |spec|
  spec.name          = "hanami-model"
  spec.version       = Hanami::Model::VERSION
  spec.authors       = ["Luca Guidi"]
  spec.email         = ["me@lucaguidi.com"]
  spec.summary       = "A persistence layer for Hanami"
  spec.description   = "A persistence framework with entities and repositories"
  spec.homepage      = "http://hanamirb.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z -- lib/* CHANGELOG.md EXAMPLE.md LICENSE.md README.md hanami-model.gemspec`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.5.0"

  spec.add_runtime_dependency "hanami-utils",    "~> 2.0.alpha"
  spec.add_runtime_dependency "rom",             "~> 5.1"
  spec.add_runtime_dependency "rom-repository",  "~> 5.1"
  spec.add_runtime_dependency "rom-sql",         "~> 3.0"
  spec.add_runtime_dependency "dry-types",       "~> 1.2"
  spec.add_runtime_dependency "dry-inflector",   "~> 0.1"
  spec.add_runtime_dependency "concurrent-ruby", "~> 1.0"

  spec.add_development_dependency "bundler", ">= 1.6", "< 3"
  spec.add_development_dependency "rake",  "~> 12"
  spec.add_development_dependency "rspec", "~> 3.8"
end
