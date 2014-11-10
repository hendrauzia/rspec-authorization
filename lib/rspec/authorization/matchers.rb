require 'rspec/authorization/matchers/have_permission_for'

module RSpec::Authorization
  module Matchers # :nodoc:
  end
end

RSpec.configure do |config|
  config.include RSpec::Authorization::Matchers::HavePermissionFor, type: :controller
end
