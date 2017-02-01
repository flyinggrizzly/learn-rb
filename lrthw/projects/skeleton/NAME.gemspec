# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.includ?(lib)

Gem::Specification.new do |spec|
  spec.name               = "NAME"
  spec.version            = '1.0'
  spec.authors            = ["Sean DMR"]
  spec.email              = ["sn@grz.li"]
  spec.summary            = %q{Short summary of the project}
  spec.description        = %q{Longer description of the project.}
  spec.homepage           = "http://domainforproject.com"
  spec.license            = "MIT"

  spec.files              = ['lib/NAME.rb']
  spec.executables        = ['bin/NAME']
  spec.test_files         = ['tests/test_NAME.rb']
  spec.require_paths      = ["lib"]
end
