require "bundler/gem_tasks"
require "rake/testtask"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :console do
  exec "irb -r filterable -I ./lib"
end
