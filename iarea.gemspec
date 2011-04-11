# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{iarea}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yoji Shidara"]
  s.date = %q{2011-04-11}
  s.description = %q{A library for DoCoMo Open Iarea.}
  s.email = %q{dara@shidara.net}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "db/iareadata.sqlite3",
    "iarea.gemspec",
    "lib/iarea.rb",
    "lib/iarea/area.rb",
    "lib/iarea/prefecture.rb",
    "lib/iarea/utils.rb",
    "lib/iarea/zone.rb",
    "lib/tasks/iarea.rake",
    "spec/iarea/area_spec.rb",
    "spec/iarea/prefecture_spec.rb",
    "spec/iarea/util_spec.rb",
    "spec/iarea/zone_spec.rb",
    "spec/spec_helper.rb",
    "tools/import_areas.rb",
    "tools/import_meshes.rb"
  ]
  s.homepage = %q{http://github.com/darashi/iarea}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{A library for DoCoMo Open Iarea.}
  s.test_files = [
    "spec/iarea/area_spec.rb",
    "spec/iarea/prefecture_spec.rb",
    "spec/iarea/util_spec.rb",
    "spec/iarea/zone_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, [">= 3.22.0"])
      s.add_runtime_dependency(%q<sqlite3-ruby>, [">= 1.3.3"])
      s.add_development_dependency(%q<rspec>, [">= 2.5.0"])
    else
      s.add_dependency(%q<sequel>, [">= 3.22.0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 1.3.3"])
      s.add_dependency(%q<rspec>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<sequel>, [">= 3.22.0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 1.3.3"])
    s.add_dependency(%q<rspec>, [">= 2.5.0"])
  end
end

