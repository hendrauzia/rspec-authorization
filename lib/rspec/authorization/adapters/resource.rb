module RSpec::Authorization
  module Adapters
    class Resource # :nodoc:
      attr_reader :restful_helper_method
      attr_writer :actions, :negated_actions
      attr_accessor :controller_class, :role

      def initialize
        @actions = @negated_actions = []
      end

      def actions
        restful_helper_method.try(:actions) || @actions
      end

      def negated_actions
        restful_helper_method.try(:negated_actions) || @negated_actions
      end

      def restful_helper_method=(method_name)
        @restful_helper_method = RestfulHelperMethod.new(method_name)
      end

      def run(actions)
        actions.map do |action|
          request = Request.new(controller_class, action, role)
          [action, request.response.status != 403]
        end
      end
    end
  end
end
