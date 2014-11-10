module RSpec::Authorization
  module Adapters
    # Create a request using wrapper around RSpec example. The request is made
    # possible through wrapping the call around RSpec example, this approach
    # is choosen because we need to get as close as possible to how the request
    # is made inside RSpec.
    #
    # Once the request is created, it will immediately run and we can evaluate the
    # response, consider the following example.
    #
    #   request = Request.new(ArticlesController, :index, :user)
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

      # Create request object and immediately run the request. Inside initialization
      # a lot of stuff get stubbed, it is to allow request to be run with assumptions,
      # following are the assumptions composed as private method run inside the
      # initializer:
      #
      # +stub_current_user+::
      #   The request is expected to run as a user with provided role. There is
      #   no user created whatsoever, it only creates a double with role_symbols
      #   defined and return it inside +current_user+.
      #
      # +stub_authorization_load_controller_object+::
      #   The request is expected to ignore declarative_authorization controller's
      #   object loading.
      #
      # +stub_authorization_load_object+::
      #   The request is expected to ignore declarative_authorization object
      #   loading. This is different from the above, and is expected to be called
      #   if controller object isn't loaded.
      #
      # +stub_callbacks+::
      #   The request is expected to ignore all callbacks defined inside the
      #   controller.
      #
      # +stub_action+::
      #   The request is expected to ignore all statements run inside the action
      #   and configured to render nothing instead.
      #
      # All of the above assumptions is expected to run only inside this request
      # only, and not to change the behavior of the application outside of this
      # request.
      #
      # @param klass [Class] controller class name to request from
      # @param action [Symbol] action name, currently only support RESTful action
      # @param role [Symbol] role name from +config/authorization_rules.rb+
      def initialize(klass, action, role)
        @klass, @action, @role = klass, action, role
        @group, @route = ExampleGroup.new(klass), Route.new(action)

        @authorization_stubbed = false

        stub_current_user
        stub_authorization_load_controller_object
        stub_authorization_load_object
        stub_callbacks
        stub_action

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

        group.before do
          user = double(:user, role_symbols: roles)
          allow(controller).to receive(:current_user).and_return(user)
        end
      end

      def stub_authorization_load_controller_object
        group.before do
          allow(controller).to receive(:load_controller_object)
        end
      end

      def stub_authorization_load_object
        return if @authorization_stubbed
        @authorization_stubbed = true

        group.before do
          Authorization::ControllerPermission.instance_eval do
            alias_method :load_object_original, :load_object
            define_method :load_object do |*args, &block|
              begin
                load_object_original(*args, &block)
              rescue ActiveRecord::RecordNotFound
              end
            end
          end
        end

        group.after do
          Authorization::ControllerPermission.instance_eval do
            remove_method :load_object

            alias_method  :load_object, :load_object_original
            remove_method :load_object_original
          end
        end
      end

      def stub_callbacks
        group.before do
          methods = controller._process_action_callbacks.map(&:filter).split(:filter_access_filter).last
          controller.instance_eval do
            methods.each do |method|
              define_singleton_method method do |*args, &block|
              end
            end
          end
        end
      end

      def stub_action
        args = route
        group.before do
          controller.instance_eval do
            define_singleton_method args.action do |*args, &block|
              render nothing: true
            end
          end
        end
      end

      def setup_response_retrieval
        args   = route
        setter = response_setter

        group.before do
          send *args
          setter.call(response)
        end
      end
    end
  end
end

