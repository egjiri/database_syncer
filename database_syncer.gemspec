# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'database_syncer/version'

Gem::Specification.new do |spec|
  spec.name          = 'database_syncer'
  spec.version       = DatabaseSyncer::VERSION
  spec.authors       = ['Endri Gjiri']
  spec.email         = ['egjiri@gmail.com']

  spec.summary       = 'Sync the local database with production data from Heroku'
  spec.description   = 'Sync the local database with production data from Heroku'
  spec.homepage      = 'https://github.com/egjiri/database_syncer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'uiux'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end
