# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scraprr/version'

Gem::Specification.new do |spec|
  spec.name          = "scraprr"
  spec.version       = Scraprr::VERSION
  spec.authors       = ["James Fargher"]
  spec.email         = ["proglottis@gmail.com"]
  spec.description   = %q{Extract structured data from HTML/XML files.}
  spec.summary       = %q{Declarative HTML/XML scraper}
  spec.homepage      = "https://github.com/proglottis/scraprr"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_dependency "nokogiri"
end
