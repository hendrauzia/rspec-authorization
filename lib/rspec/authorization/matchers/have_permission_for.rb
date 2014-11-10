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
      # Currently this matcher only support RESTful action check, to check the
      # controller against +config/authorization_rules.rb+. Skipping the +#to+
      # method will result in default action assigned as +:index+.
      #
      # Therefore, the following statement is exactly the same as above:
      #
      #   it { is_expected.to have_permission_for(:user) }
      #
      # === RESTful methods
      #
      # For your convenience, there are 4 RESTful methods available to be chained
      # from the matcher, which are:
      #
      # - +to_read+
      # - +to_create+
      # - +to_update+
      # - +to_delete+
      #
      # Consider the following example:
      #
      #   it { is_expected.to have_permission_for(:user).to_read }
      #   it { is_expected.to have_permission_for(:user).to_edit }
      #   it { is_expected.not_to have_permission_for(:user).to_update }
      #   it { is_expected.not_to have_permission_for(:user).to_delete }
      #
      # The above method is not related to declarative_authorization privileges,
      # and serve simply as convinience method, below is a table of RESTful actions
      # for each method mentioned above:
      #
      #   Method         RESTful action
      #   ------------------------------------
      #   to_read       [:index, :show]
      #   to_edit       [:edit, :update]
      #   to_create     [:new, :create]
      #   to_delete     [:destroy]
      #
      # Matcher for RESTful methods is slightly different than that of a single
      # method, following is how RESTful methods request results evaluated:
      #
      #   all_requests (of #to_read)       matches?     does_not_match?
      #   -------------------------------------------------------------------
      #   {index: true, show: true}        true         false
      #   {index: true, show: false}       false        false
      #   {index: false, show: false}      false        true
      #
      # @param role [Symbol] role name to matched against
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

        def to_read
          @behave  = :read
          @actions = %i(index show)

          self
        end

        def to_create
          @behave  = :create
          @actions = %i(new create)

          self
        end

        def to_update
          @behave  = :update
          @actions = %i(edit update)

          self
        end

        def to_delete
          @behave  = :delete
          @actions = %i(destroy)

          self
        end

        def to_manage
          @behave  = :manage
          @actions = %i(index show new create edit update destroy)

          self
        end

        def all_requests
          actions.map do |action|
            request = Request.new(controller.class, action, role)
            [action, request.response.status != 403]
          end
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
      end
    end
  end
end

