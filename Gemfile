source 'https://rubygems.org'
ruby '2.1.4'

gemspec

group :development, :test do
  gem 'declarative_authorization', github: 'stffn/declarative_authorization'
  gem 'guard-rspec'
  gem 'pry'
  gem 'terminal-notifier-guard' if `uname` =~ /Darwin/

  gem 'jquery-rails'
  gem 'turbolinks'
end
