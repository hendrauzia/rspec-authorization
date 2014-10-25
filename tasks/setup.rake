require 'rails/version'
require 'rails_test_app'

desc "Create a test rails app for the specs to run against"
task :setup do
  rails = RailsTestApp.new(Rails::VERSION::STRING)
  rails.create
end

