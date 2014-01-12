# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-stencil/version'

Gem::Specification.new do |spec|
  spec.name          = "knife-stencil"
  spec.version       = Knife::Stencil::VERSION
  spec.authors       = ["sam"]
  spec.email         = ["sam.pointer@opsunit.com"]
  spec.description   = %q{Chef knife plugin stencil system with multi-cloud support}
  spec.summary       = %q{Chef Knife plugin stencil system. Pass only the hostname and inherit all other options. Seamlessly launch in multiple clouds}
  spec.homepage      = "https://github.com/opsunit/knife-stencil"
  spec.license       = "GPL3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0.9"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "bump", "~> 0.5"

  spec.add_dependency "chef", "~> 11.6.0"
  spec.add_dependency "json"
end
