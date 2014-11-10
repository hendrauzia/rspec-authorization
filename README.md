# RSpec::Authorization

[![Gem Version](https://badge.fury.io/rb/rspec-authorization.svg)](http://badge.fury.io/rb/rspec-authorization)
[![Build Status](https://travis-ci.org/hendrauzia/rspec-authorization.svg)](https://travis-ci.org/hendrauzia/rspec-authorization)
[![Code Climate](https://codeclimate.com/github/hendrauzia/rspec-authorization/badges/gpa.svg)](https://codeclimate.com/github/hendrauzia/rspec-authorization)
[![Test Coverage](https://codeclimate.com/github/hendrauzia/rspec-authorization/badges/coverage.svg)](https://codeclimate.com/github/hendrauzia/rspec-authorization)
[![Dependency Status](https://gemnasium.com/hendrauzia/rspec-authorization.svg)](https://gemnasium.com/hendrauzia/rspec-authorization)
[![security](https://hakiri.io/github/hendrauzia/rspec-authorization/master.svg)](https://hakiri.io/github/hendrauzia/rspec-authorization/master)
[![Inline docs](http://inch-ci.org/github/hendrauzia/rspec-authorization.svg?branch=master)](http://inch-ci.org/github/hendrauzia/rspec-authorization)

RSpec matcher for declarative_authorization. A neat way of asserting
declarative_authorization's rules inside controller using RSpec matcher.

## Installation

Add this line to your application's Gemfile:


    gem 'rspec-authorization', group: :test


And then execute:

    bundle

Or install it yourself as:

    gem install rspec-authorization

## Requirement

Current development focus is as follows, future development may support other
dependencies, following are requirements for this gem:

- declarative_authorization 1.0.0.pre
- rails 4.x
- rspec-rails 3.x

## Usage

In your controller spec:

    describe ArticlesController do
      it { is_expected.to have_permission_for(:role_name).to(:restful_action_name) }
    end

## Contributing

1. Fork it ( https://github.com/hendrauzia/rspec-authorization/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Setup rails test app (`bundle exec rake setup`)
3. Test your changes (`bundle exec rake spec`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request
