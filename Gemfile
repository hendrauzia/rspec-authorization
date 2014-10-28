source 'https://rubygems.org'
ruby '2.1.4'

gemspec

group :development, :test do
  gem 'guard-rspec'
  gem 'pry'
  gem 'terminal-notifier-guard' if `uname` =~ /Darwin/  
end
