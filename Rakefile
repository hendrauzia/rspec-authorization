$LOAD_PATH << File.expand_path('../tools', __FILE__)

require 'rspec/core/rake_task'
require "bundler/gem_tasks"

# Default directory to look is `/spec`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec)
task default: :spec

Dir["tasks/*.rake"].each do |task|
  import task
end
