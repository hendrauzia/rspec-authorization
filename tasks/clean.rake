require 'rails/version'
require 'rails_test_app'

desc "Cleanup test rails apps"
task :clean do
  rails = RailsTestApp.new(Rails::VERSION::STRING)
  puts "#{rails.path} has been deleted" if rails.destroy
end
