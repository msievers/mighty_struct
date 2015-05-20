require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :benchmark do
  require_relative "./benchmark/mighty_struct/mighty_struct_versus_others"

  Benchmark::MightyStruct::MightyStructVersusOthers.new.call
end
