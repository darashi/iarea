require 'psych'
load 'lib/tasks/iarea.rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "iarea"
    gem.summary = "A library for DoCoMo Open Iarea."
    gem.description = "A library for DoCoMo Open Iarea."
    gem.email = "dara@shidara.net"
    gem.homepage = "http://github.com/darashi/iarea"
    gem.authors = ["Yoji Shidara"]

    gem.add_dependency "sequel", ">= 3.22.0"
    gem.add_dependency "sqlite3-ruby", ">= 1.3.3"

    gem.add_development_dependency "rspec", ">= 2.5.0"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Jeweler::GemcutterTasks.new

require 'rspec/core/rake_task.rb'
RSpec::Core::RakeTask.new(:test) do |t|
  t.verbose = true
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "iarea #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
