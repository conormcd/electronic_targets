require 'cane/rake_task'
require 'rake/clean'
require 'rspec/core/rake_task'

CLEAN << "coverage"

desc "Run tests"
RSpec::Core::RakeTask.new do |r|
  r.rspec_opts = '-cbfd'
end

desc 'Run cane to check quality metrics'
Cane::RakeTask.new(:hygiene) do |cane|
  cane.abc_max = 15
  cane.abc_glob = "**/*.rb"
  cane.style_measure = 80
  cane.style_glob = "**/*.rb"
end

task :default => [:hygiene, :spec]
