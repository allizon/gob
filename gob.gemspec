# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gob/version'

Gem::Specification.new do |spec|
  spec.name          = 'gob'
  spec.version       = Gob::VERSION
  spec.authors       = ['Allison Holt']
  spec.email         = ['hey@alli.fyi']

  spec.summary       = %q{Create "generic objects" with lots of magical syntactical sugar!}
  spec.homepage      = %q{https://github.com/allizon/gob}

  spec.files         = `git ls-files -z lib`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'mocha', '~> 1.1'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
end
