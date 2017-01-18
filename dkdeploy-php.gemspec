# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dkdeploy/php/version'

Gem::Specification.new do |spec|
  spec.name          = 'dkdeploy-php'
  spec.version       = Dkdeploy::Php::Version
  spec.license       = 'MIT'
  spec.authors       = ['Lars Tode', 'Timo Webler', 'Kieran Hayes', 'Nicolai Reuschling']
  spec.email         = ['lars.tode@dkd.de', 'timo.webler@dkd.de', 'kieran.hayes@dkd.de', 'nicolai.reuschling@dkd.de']
  spec.description   = 'dkd PHP deployment tasks and strategies'
  spec.summary       = 'dkd php deployment tasks and strategies'
  spec.homepage      = 'https://github.com/dkdeploy/dkdeploy-php'
  spec.required_ruby_version = '~> 2.1'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin\/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)\/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12.5'
  spec.add_development_dependency 'rake', '~> 11.2'
  spec.add_development_dependency 'rubocop', '0.46'
  spec.add_development_dependency 'dkdeploy-test_environment', '~> 1.0'

  spec.add_dependency 'dkdeploy-core', '~> 8.0'
end
