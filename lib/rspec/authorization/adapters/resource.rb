module RSpec::Authorization
  module Adapters
    class Resource # :nodoc:
      attr_reader :klass, :actions, :role, :results

      def initialize(klass, actions, role)
        @klass, @actions, @role = klass, actions, role
        @results = run_requests(actions)
      end

      private

      def run_requests(actions)
        actions.map do |action|
          request = Request.new(klass, action, role)
          [action, request.response.status != 403]
        end
      end
    end
  end
end
