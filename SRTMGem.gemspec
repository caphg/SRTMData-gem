# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'SRTMGem/version'

Gem::Specification.new do |spec|
  spec.name          = "SRTMGem"
  spec.version       = SRTMGem::VERSION
  spec.authors       = ["sykhira"]
  spec.email         = ["caphg@hotmail.com"]
  spec.description   = "Gem parses SRTM data and for given latitude/longitude returns the elevation for that point, or nearest interpolated."
  spec.summary       = "Returns elevation for given logitude/latitude from SRTM data.re"
  spec.homepage      = "https://github.com/caphg/SRTMData-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
