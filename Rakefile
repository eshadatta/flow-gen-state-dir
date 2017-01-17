begin
  require 'rspec/core/rake_task'

  task :default => :spec

  desc "Run all tests"
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.pattern = "spec/**/*.rb"
  end

  desc "creates state directories"
  task :setup do
    sh "./create_flow_state_dirs"
  end


rescue LoadError
  # undefined tasks
end
