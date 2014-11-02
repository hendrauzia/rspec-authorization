require 'rails/version'
require 'rails_test_app'

desc "Create a test rails app for the specs to run against"
task :setup do
  system('rm -rf config')

  rails = RailsTestApp.new(Rails::VERSION::STRING)
  puts "#{rails.path} exists!" unless rails.create
end

