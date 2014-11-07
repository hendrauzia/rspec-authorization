module RSpec::Authorization
  module Matchers
    # Include this module to enable the +have_permission_for+ matcher inside RSpec.
    # The following module is to be included only inside controller spec, this will
    # add the capability to do a matcher against decalrative_authorization rules as
    # follows:
    #
    #   it { is_expected.to have_permission_for(:user).to(:index) }
    #
    # For your convinience, the following configuration has been enabled inside
    # RSpec configuration.
    #
    #   RSpec.configure do |config|
    #     config.include RSpec::Authorization::Matchers::HavePermissionFor, type: :controller
    #   end
    module HavePermissionFor
      # Matcher to check permission of a role for a given controller in a spec. The
      # following statement shows you how to use this matcher:
      #
      #   describe PostsController do
      #     it { is_expected.to have_permission_for(:user).to(:index) }
      #   end
      #
      # Currently this matcher only support RESTful action check, to check the
      # controller against +config/authorization_rules.rb+. Skipping the +#to+
      # method will result in default action assigned as +:index+.
      #
      # Therefore, the following statement is exactly the same as above:
      #
      #   it { is_expected.to have_permission_for(:user) }
      #
      # @param role [Symbol] role name to matched against
      def have_permission_for(role)
        HavePermissionFor.new(role)
      end

      class HavePermissionFor
        include Adapters

        attr_reader :controller, :role, :action

        def initialize(role)
          @role   = role
          @action = :index
        end

        def to(action)
          @action = action
          self
        end

        def matches?(controller)
          @controller = controller

          request = Request.new(controller.class, action, role)
          request.response.status != 403
        end

        def failure_message
          "Expected #{controller.class} to have permission for #{role} to #{action}"
        end

        def failure_message_when_negated
          "Did not expect #{controller.class} to have permission for #{role} to #{action}"
        end

        def description
          "have permission for #{role} on #{action}"
        end
      end
    end
  end
end

