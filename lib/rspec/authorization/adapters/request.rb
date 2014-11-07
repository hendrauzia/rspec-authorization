module RSpec::Authorization
  module Adapters
    # This class is used to create a request using wrapper around RSpec example.
    # The request is made possible through wrapping the call around RSpec example,
    # this approach is choosen because we need to get as close as possible to how
    # the request is made inside RSpec.
    #
    # Once the request is created, it will immediately run and we can evaluate the
    # response, consider the following example.
    #
    #   request = Request.new(PostsController, :index, :user)
    #   request.response.status # => 200
    #
    # Since the request is actually creating a request to the provided controller,
    # it will run everything inside the controller, and no stubbing is performed.
    # Therefore exception inside controller will bubble up to the request and may
    # cause unexpected result. That is with one exception, there is one exception,
    # ActiveRecord::RecordNotFound is rescued and bypassed, therefore it will not
    # affect the request.
    class Request
      # @return [Class] controller class name
      attr_reader :klass
      # @return [Symbol] controller action name
      attr_reader :action
      # @return [Symbol] role name from +config/authorization_rules.rb+
      attr_reader :role
      # @return [ExampleGroup] example group of the request
      # @see ExampleGroup
      attr_reader :group
      # @return [Route] route object of the action
      # @see Route
      attr_reader :route
      # @return [ActionController::TestResponse] response object of the request
      attr_reader :response

      # Create request object and immediately run the request.
      #
      # @param klass [Class] controller class name to request from
      # @param action [Symbol] action name, currently only support RESTful action
      # @param role [Symbol] role name from +config/authorization_rules.rb+
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

