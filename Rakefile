require 'rspec/core/rake_task.rb'
RSpec::Core::RakeTask.new(:test) do |t|
  t.verbose = true
end

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  require_relative 'lib/iarea/version'
  version = Iarea::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "iarea #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test

require 'bundler/gem_tasks'
load './lib/tasks/iarea.rake'
