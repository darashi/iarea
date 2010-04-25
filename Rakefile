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

    gem.add_dependency "sequel", ">= 3.10.0"
    gem.add_dependency "sqlite3", ">= 1.2.5"

    gem.add_development_dependency "rspec", ">= 1.3.0"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Jeweler::GemcutterTasks.new

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:test) do |t|
  t.spec_files = FileList['test/**/*_test.rb']
  t.libs << 'test'

  t.verbose = true
end

task :default => :test
