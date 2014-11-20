module RSpec::Authorization
  module Adapters
    class Resource # :nodoc:
      attr_reader :restful_helper_method
      attr_accessor :controller_class, :role

      delegate :prefix, to: :restful_helper_method

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
