source 'https://rubygems.org'
gemspec

group :development, :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'declarative_authorization', github: 'stffn/declarative_authorization'
  gem 'devise'
  gem 'guard-rspec'
  gem 'jquery-rails'

  gem 'pry'
  gem 'pry-byebug'
  gem 'terminal-notifier-guard' if `uname` =~ /Darwin/
  gem 'turbolinks'
end

group :test do
  gem 'shoulda-matchers', require: false
end

group :docs do
  gem "inch"
  gem "rdoc"
  gem "yard"
end
