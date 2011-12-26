# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sprockets/image_compressor/version"

Gem::Specification.new do |s|
  s.name        = "sprockets-image_compressor"
  s.version     = Sprockets::Imagecompressor::VERSION
  s.authors     = ["Micah Geisel"]
  s.email       = ["micah@botandrose.com"]
  s.homepage    = ""
  s.summary     = %q{Losslessly compress images in the Rails asset pipeline}
  s.description = %q{Losslessly compress images in the Rails asset pipeline}

  s.rubyforge_project = "sprockets-image_compressor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "sprockets"

  s.add_development_dependency "ruby-debug"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rack-test"
end
