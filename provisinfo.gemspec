# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'provisinfo/version'

Gem::Specification.new do |spec|
  spec.name          = "provisinfo"
  spec.version       = Provisinfo::VERSION
  spec.authors       = ["Oswaldo Rubio"]
  spec.email         = ["osrufung@gmail.com"]

  spec.summary       = %q{A provisioning profile CLI inspector}
  spec.description   = %q{A simple provisioning profile CLI inspector to extract metadata from .mobileprovision file.}
  spec.homepage      = "https://github.com/osrufung/provisinfo"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   << 'provisinfo'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency 'commander', '~> 4.1'
  spec.add_dependency 'plist', '~> 3.1.0'
end
