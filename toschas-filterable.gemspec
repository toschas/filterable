# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toschas/filterable/version'

Gem::Specification.new do |spec|
  spec.name          = "toschas-filterable"
  spec.version       = Filterable::VERSION
  spec.authors       = ["Darjan Vukusic"]
  spec.email         = ["darjan.vukusic@gmail.com"]

  spec.summary       = %q{Easy filtering of Active Record objects}
  spec.description   = %q{Filterable gem aims to simplify the process of filtering active record objects.It provides an easy way to define filters on the model (without having to write scopes) and apply them on any active record collection.}
  spec.homepage      = "https://github.com/toschas/filterable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sqlite3"

  spec.add_dependency "activerecord", ">= 3.0"
end
