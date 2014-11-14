require "rspec/authorization/matchers/have_permission_for/restful_helper_method"

module RSpec::Authorization
  module Matchers
    # Include this module to enable the +have_permission_for+ matcher inside RSpec.
    # The following module is to be included only inside controller spec, this will
    # add the capability to do a matcher against decalrative_authorization rules as
    # follows:
    #
    #   it { is_expected.to have_permission_for(:user).to(:index) }
    #
    # For your convenience, the following configuration has been enabled inside
    # RSpec configuration.
    #
    #   RSpec.configure do |config|
    #     config.include RSpec::Authorization::Matchers::HavePermissionFor, type: :controller
    #   end
    module HavePermissionFor
      # Matcher to check permission of a role for a given controller in a spec. The
      # following statement shows you how to use this matcher:
      #
      #   describe ArticlesController do
      #     it { is_expected.to have_permission_for(:user).to(:index) }
      #   end
      #
      # Currently this matcher only support restful action check, to check the
      # controller against +config/authorization_rules.rb+. Skipping the +#to+
      # method will result in default action assigned as +:index+.
      #
      # Therefore, the following statement is exactly the same as above:
      #
      #   it { is_expected.to have_permission_for(:user) }
      #
      # === RESTful helper methods
      #
      # For your convenience, there are restful helper methods available to be chained
      # from the matcher, consider the following example:
      #
      #   it { is_expected.to have_permission_for(:user).to_read }
      #   it { is_expected.to have_permission_for(:user).to_create }
      #   it { is_expected.not_to have_permission_for(:user).to_update }
      #   it { is_expected.not_to have_permission_for(:user).to_delete }
      #   it { is_expected.not_to have_permission_for(:user).to_manage }
      #
      # Matcher for restful helper methods is slightly different than that of a single
      # method, following is how restful helper methods request results evaluated:
      #
      #   all_requests (of #to_read)       matches?     does_not_match?
      #   -------------------------------------------------------------------
      #   {index: true, show: true}        true         false
      #   {index: true, show: false}       false        false
      #   {index: false, show: false}      false        true
      #
      # @param role [Symbol] role name to matched against
      # @see RestfulHelperMethod
      def have_permission_for(role)
        HavePermissionFor.new(role)
      end

      class HavePermissionFor # :nodoc: all
        include Adapters

        attr_reader :controller, :role, :behave, :actions, :results

        def initialize(role)
          @role = role
        end

        def to(action)
          @behave  = action
          @actions = [behave]

          self
        end

        def method_missing(method_name, *args, &block)
          @behave, @actions = RestfulHelperMethod.new(method_name)

          self
        end

        def matches?(controller)
          @controller = controller
          @results    = Hash[all_requests]

          true unless results.value? false
        end

        def does_not_match?(controller)
          @controller = controller
          @results    = Hash[all_requests]

          true unless results.value? true
        end

        def failure_message
          "Expected #{controller.class} to have permission for #{role} to #{behave}. #{results}"
        end

        def failure_message_when_negated
          "Did not expect #{controller.class} to have permission for #{role} to #{behave}. #{results}"
        end

        def description
          "have permission for #{role} to #{behave}"
        end

        private

        def all_requests
          actions.map do |action|
            request = Request.new(controller.class, action, role)
            [action, request.response.status != 403]
          end
        end
      end
    end
  end
end

