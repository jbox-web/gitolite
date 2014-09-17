require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
require 'ci/reporter/rake/rspec'
require 'rspec/core/rake_task'
require 'rdoc/task'

## Helper Functions
def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end


def version
  line = File.read("lib/#{name}/version.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end


## RDoc Task
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "#{name} #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


## Other Tasks
desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end


desc "Show library version"
task :version do
  puts "#{name} #{version}"
end


namespace :gitolite do
  ENV["CI_REPORTS"] = "./junit"

  desc "Configure unit tests"
  RSpec::Core::RakeTask.new(:config_rspec) do |task|
    task.rspec_opts = "--color"
  end

  desc "Start unit tests"
  task :ci => ['ci:setup:rspec', :config_rspec]
end

task :default => "gitolite:ci"
task :spec    => "gitolite:ci"
task :rspec   => "gitolite:ci"
task :test    => "gitolite:ci"
