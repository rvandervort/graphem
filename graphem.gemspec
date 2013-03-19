# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphem/version'

Gem::Specification.new do |gem|
  gem.name          = "graphem"
  gem.version       = Graphem::VERSION
  gem.authors       = ["Roger Vandervort"]
  gem.email         = ["rvandervort@gmail.com"]
  gem.description   = %q{Simple graph processing in Ruby}
  gem.summary       = %q{Simple graph processing in Ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
