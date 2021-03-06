# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'value_project/version'

Gem::Specification.new do |spec|
  spec.name          = "value_project"
  spec.version       = ValueProject::VERSION
  spec.authors       = ["mgi166"]
  spec.email         = ["skskoari@gmail.com"]

  spec.summary       = %q{Notify ff value to everyone.}
  spec.description   = %q{Notify ff value to everyone.}
  spec.homepage      = "https://github.com/feedforce/value-project"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest-emoji"
  spec.add_development_dependency "minitest-power_assert"

  spec.add_dependency 'slack-ruby-client'
  spec.add_dependency 'google_drive'
  spec.add_dependency 'redis-objects'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'celluloid-io'
  spec.add_dependency 'hashie'
  spec.add_dependency 'foreman'
  spec.add_dependency "pry" # for debug in heroku.
end
