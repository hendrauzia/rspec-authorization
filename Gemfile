source 'https://rubygems.org'
ruby '2.1.4'

gemspec

group :development, :test do
  gem 'declarative_authorization', github: 'stffn/declarative_authorization'
  gem 'guard-rspec'
  gem 'pry'
  gem 'terminal-notifier-guard' if `uname` =~ /Darwin/
  gem "codeclimate-test-reporter", require: nil

  gem 'jquery-rails'
  gem 'turbolinks'
end

group :docs do
  gem "rdoc"
  gem "yard"
end
