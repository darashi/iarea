# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "iarea/version"

Gem::Specification.new do |s|
  s.name        = "iarea"
  s.version     = Iarea::VERSION
  s.authors     = ["SHIDARA Yoji"]
  s.email       = ["dara@shidara.net"]
  s.homepage    = "http://github.com/darashi/iarea"
  s.summary     = %q{A library for DoCoMo Open Iarea.}
  s.description = %q{A library for DoCoMo Open Iarea.}

  s.rubyforge_project = "iarea"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'leveldb-ruby'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
end
