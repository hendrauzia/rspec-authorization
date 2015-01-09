module RSpec::Authorization
  module Adapters
    class Resource # :nodoc:
      attr_reader :results, :negated_results
      attr_accessor :controller_class, :role, :actions, :negated_actions

      def initialize
        @actions = @negated_actions = []
      end

      def run(actions)
        actions.map do |action|
          request = Request.new(controller_class, action, role)
          [action, request.response.status != 403]
        end
      end

      def run_all
        requests
        negated_requests
      end

      def permitted?
        permitted_or_forbidden?(:permitted_for?, :forbidden_for?)
      end

      def forbidden?
        permitted_or_forbidden?(:forbidden_for?, :permitted_for?)
      end

      private

      def requests
        @results = Hash[run(actions)]
      end

      def negated_requests
        @negated_results = Hash[run(negated_actions)]
      end

      def permitted_or_forbidden?(primary, secondary)
        send(primary, results) && (negated_results.present? ? send(secondary, negated_results) : true)
      end

      def permitted_for?(requests)
        true unless requests.value? false
      end

      def forbidden_for?(requests)
        true unless requests.value? true
      end
    end
  end
end
