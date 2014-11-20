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
      # For your convenience, there are restful helper methods available to be
      # chained from the matcher, consider the following example:
      #
      #   it { is_expected.to have_permission_for(:user).to_read }
      #   it { is_expected.to have_permission_for(:user).to_create }
      #   it { is_expected.not_to have_permission_for(:user).to_update }
      #   it { is_expected.not_to have_permission_for(:user).to_delete }
      #   it { is_expected.not_to have_permission_for(:user).to_manage }
      #
      # Matcher for restful helper methods is slightly different than that of
      # a single method, following is an example of how restful helper methods
      # request results evaluated:
      #
      #   all_requests (of #to_read)       matches?     does_not_match?
      #   -------------------------------------------------------------------
      #   {index: true, show: true}        true         false
      #   {index: true, show: false}       false        false
      #   {index: false, show: false}      false        true
      #
      # === Focused RESTful helper methods
      #
      # There are cases where you need to focused your matching only for a given
      # criteria, let's say only match for read actions, or match except delete
      # action, consider the following example:
      #
      #   it { is_expected.to have_permission_for(:user).only_to_read }
      #   it { is_expected.to have_permission_for(:writer).except_to_delete }
      #
      # The above statements have their negated counterparts, consider the
      # following example:
      #
      #   it { is_expected.not_to have_permission_for(:user).only_to_read }
      #   it { is_expected.not_to have_permission_for(:writer).only_to_delete }
      #
      # If you see the above negated matcher, they actually have a relationship
      # to the other's negated counterpart instead of theirs, consider the following
      # example:
      #
      #   it { is_expected.to have_permission_for(:user).only_to_read }
      #   it { is_expected.not_to have_permission_for(:user).except_to_read }
      #
      # The above examples are doing exactly the same thing, so does the following
      # example, these examples below also doing exactly the same thing and can
      # be used in either case:
      #
      #   it { is_expected.to have_permission_for(:writer).except_to_delete }
      #   it { is_expected.not_to have_permission_for(:writer).only_to_read }
      #
      # That means, the following example, is actually negating each other and
      # can be used to negate your statements instead of using the negated version
      # of the matcher:
      #
      #   it { is_expected.to have_permission_for(:user).only_to_read }
      #   it { is_expected.to have_permission_for(:user).except_to_read }
      #
      # Even if you can have a negated matcher using a focused restful helper
      # methods, it is better to stick with the possitive matcher, negated matcher
      # can easily confuse you, and it only serves the purpose of completeness.
      #
      # @param role [Symbol] role name to matched against
      # @see RestfulHelperMethod
      def have_permission_for(role)
        HavePermissionFor.new(role)
      end

      class HavePermissionFor # :nodoc: all
        include Adapters

        attr_reader :controller, :role, :prefix, :behave, :actions, :negated_actions, :results, :negated_results, :resource

        def initialize(role)
          @role    = role
          @actions = @negated_actions = []

          @resource     = Resource.new
          resource.role = role
        end

        def to(action)
          @prefix  = :to
          @behave  = action
          @actions = [behave]

          self
        end

        def method_missing(method_name, *args, &block)
          resource.restful_helper_method = method_name
          @prefix, @behave, @actions, @negated_actions = resource.restful_helper_method

          self
        end

        def matches?(controller)
          resource.controller_class = controller.class

          run_all_requests(controller)
          permitted_or_forbidden?(:permitted?, :forbidden?)
        end

        def does_not_match?(controller)
          resource.controller_class = controller.class

          run_all_requests(controller)
          permitted_or_forbidden?(:forbidden?, :permitted?)
        end

        def failure_message
          "Expected #{common_failure_message}"
        end

        def failure_message_when_negated
          "Did not expect #{common_failure_message}"
        end

        def description
          "have permission for #{role} #{prefix_formatted} #{behave}"
        end

        private

        def prefix_formatted
          prefix.to_s.sub("_", " ")
        end

        def common_failure_message
          "#{controller.class} to #{description}. #{debug_results}"
        end

        def debug_results
          "results: #{results}, negated_results: #{negated_results}"
        end

        def permitted_or_forbidden?(primary, secondary)
          send(primary, results) && (negated_results.present? ? send(secondary, negated_results) : true)
        end

        def permitted?(requests)
          true unless requests.value? false
        end

        def forbidden?(requests)
          true unless requests.value? true
        end

        def requests
          run_requests(actions)
        end

        def negated_requests
          run_requests(negated_actions)
        end

        def run_requests(params)
          resource.run(params)
        end

        def run_all_requests(controller)
          @controller = controller

          @results         = Hash[requests]
          @negated_results = Hash[negated_requests]
        end
      end
    end
  end
end

