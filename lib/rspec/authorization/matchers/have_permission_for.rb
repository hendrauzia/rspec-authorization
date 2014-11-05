module RSpec::Authorization
  module Matchers
    module HavePermissionFor
      def have_permission_for(role)
        HavePermissionFor.new(role)
      end

      # @private
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

