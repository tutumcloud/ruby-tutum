require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :spec do |t|
  t.rspec_opts = '--color --order random'
  t.verbose = false
end

task :default => :spec