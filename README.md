# RSpec::Authorization

[![GitHub](http://img.shields.io/badge/github-hendrauzia/rspec--authorization-blue.svg)](http://github.com/hendrauzia/rspec-authorization)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://rubydoc.org/github/hendrauzia/rspec-authorization)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](#license)

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


    gem 'rspec-authorization', group: :test, require: false


Add this to `spec_helper.rb`:


    require 'rspec/authorization'


And then execute:

    bundle

Or install it yourself as:

    gem install rspec-authorization

## Requirement

Current development focus is as follows, future development may support other
dependencies, following are requirements for this gem:

- declarative_authorization 1.0.0.pre
- rails 4.x
- rspec-rails 3.1.x

## Usage

In your controller spec:

    describe ArticlesController do
      it { is_expected.to have_permission_for(:a_role).to(:restful_action_name) }

      it { is_expected.to have_permission_for(:writer).to(:index) }
      it { is_expected.to have_permission_for(:writer).to(:show) }
      it { is_expected.to have_permission_for(:writer).to(:new) }
      it { is_expected.to have_permission_for(:writer).to(:create) }
      it { is_expected.not_to have_permission_for(:writer).to(:edit) }
      it { is_expected.not_to have_permission_for(:writer).to(:update) }
      it { is_expected.not_to have_permission_for(:writer).to(:destroy) }
    end

You can also use convenience restful helper methods:

    describe ArticlesController do
      it { is_expected.to have_permission_for(:user).to_read }
      it { is_expected.not_to have_permission_for(:user).to_create }
      it { is_expected.not_to have_permission_for(:user).to_update }
      it { is_expected.not_to have_permission_for(:user).to_delete }

      it { is_expected.to have_permission_for(:writer).to_read }
      it { is_expected.to have_permission_for(:writer).to_create }
      it { is_expected.to have_permission_for(:writer).to_update }
      it { is_expected.not_to have_permission_for(:writer).to_delete }

      it { is_expected.to have_permission_for(:editor).to_manage }
    end

Or you can also use the focused restful helper method as follows:

    describe ArticlesController do
      it { is_expected.to have_permision_for(:user).only_to_read }
      it { is_expected.to have_permision_for(:writer).except_to_delete }
    end

## History

See {file:HISTORY.md} for history of changes.

## License

rspec-authorization &copy; 2014 by Hendra Uzia. rspec-authorization is
licensed under the MIT license except for some files which come from the
RDoc/Ruby distributions. Please see the {file:LICENSE.txt} documents
for more information.

## Contributing

1. Fork it ( https://github.com/hendrauzia/rspec-authorization/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Setup rails test app (`bundle exec rake setup`)
3. Test your changes (`bundle exec rake spec`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request
