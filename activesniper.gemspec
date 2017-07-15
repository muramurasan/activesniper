# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activesniper/version'

Gem::Specification.new do |spec|
  spec.name          = "activesniper"
  spec.version       = ActiveSniper::VERSION
  spec.authors       = ["Yasuhiro Matsumura"]
  spec.email         = ["ym.contributor@gmail.com"]

  spec.summary       = %q{Launch callback when find change of specified column in activerecord.}
  spec.description   = %q{Launch callback when find change of specified column in activerecord.}
  spec.homepage      = "https://github.com/muramurasan/activesniper"
  spec.license       = "MIT"

  spec.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~> 1.0"
  spec.add_dependency "activerecord", ">= 3.0.0"
end
