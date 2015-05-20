# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mighty_struct/version"

Gem::Specification.new do |spec|
  spec.name          = "mighty_struct"
  spec.version       = MightyStruct::VERSION
  spec.authors       = ["Michael Sievers"]
  spec.summary       = %q{A mighty struct which combines OpenStruct like method access with reasonable performance.}
  spec.homepage      = "https://github.com/msievers/mighty_struct"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "bundler",   ">= 1.3"
  spec.add_development_dependency "hashie"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",     ">= 3.0.0",  "< 4.0.0"
  spec.add_development_dependency "simplecov", ">= 0.8.0"
end
