# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.includ?(lib)

Gem::Specification.new do |spec|
  spec.ex47               = "ex47"
  spec.version            = '0.1'
  spec.authors            = ["Sean DMR"]
  spec.email              = ["sn@grz.li"]
  spec.summary            = %q{Short summary of the project}
  spec.description        = %q{Longer description of the project.}
  spec.homepage           = "http://domainforproject.com"
  spec.license            = "MIT"

  spec.files              = ['lib/ex47.rb']
  spec.executables        = ['bin/ex47']
  spec.test_files         = ['tests/test_ex47.rb']
  spec.require_paths      = ["lib"]
end
