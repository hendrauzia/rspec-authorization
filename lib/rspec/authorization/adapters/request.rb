module RSpec::Authorization
  module Adapters
    class Request
      attr_reader :klass, :action, :role, :group, :route, :response

      def initialize(klass, action, role)
        @klass, @action, @role = klass, action, role
        @group, @route = ExampleGroup.new(klass), Route.new(action)

        stub_current_user

        setup_response_retrieval
        group.run_example
      end

      private

      def response_setter
        lambda { |r| @response = r }
      end

      def role_symbols
        [role]
      end

      def stub_current_user
        roles  = role_symbols

        group.push do
          user = double(:user, role_symbols: roles)
          allow(controller).to receive(:current_user).and_return(user)
        end
      end

      def setup_response_retrieval
        args   = route
        setter = response_setter

        group.push do
          begin
            send *args
          rescue ActiveRecord::RecordNotFound
            response.status = 404
          end

          setter.call(response)
        end
      end
    end
  end
end

