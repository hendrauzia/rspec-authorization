module RSpec::Authorization
  module Adapters
    # Wrapper to generate +RSpec::Core::ExampleGroup+. The example group
    # includes +RSpec::Rails::ControllerExampleGroup+ to add behavior testing,
    # which provides methods to test the controller, such as: +get+, +post+,
    # +patch+, +put+ and +delete+.
    #
    # Consider the following example:
    #
    #   group = ExampleGroup.new(ArticlesController)
    #   group.target # => RSpec::ExampleGroups::ArticlesController
    #
    # Instantiating the class for a second time produce a different result:
    #
    #   group = ExampleGroup.new(ArticlesController)
    #   group.target # => RSpec::ExampleGroups::ArticlesController_2
    class ExampleGroup
      # @return [Class] a class namespaced from +RSPec::ExampleGroups+
      attr_reader :target

      # Initialize example group using controller's class.
      #
      # @param klass [Class] controller's class for an example group
      def initialize(klass)
        @target = RSpec::Core::ExampleGroup.describe(klass) do
          include RSpec::Rails::ControllerExampleGroup
        end
      end

      # Run example for our example group. The example is actualy has
      # no example at all, it is simply a wrapper for +RSpec::Core::Example+,
      # running an actual example would produce unnecessary artifacts, while all
      # we need is a simple wrapper on controller behavior.
      #
      # @return [Example] example object that has been run
      # @see Example
      def run_example
        Example.new(target)
      end

      # Add instruction to be run before our example. Instructions added will be
      # run inside the context of our example group, consider the following
      # example:
      #
      #   before do
      #     get :index
      #   end
      #
      # The above statements behave exactly the same as RSpec +before+ method, and
      # this method serve as a proxy to RSpec +before+ method call. That means
      # everything that we can do inside +before+ method will be available inside
      # +before+ to.
      #
      # @return [Array<RSpec::Core::Hooks::BeforeHook>] an array of before hook filter
      def before(&block)
        target.before(&block)
      end

      # Add instruction to be run after our example. Instructions added will be
      # run inside the context of our example group, consider the following
      # example:
      #
      #   after do
      #     get :index
      #   end
      #
      # The above statements behave exactly the same as RSpec +after+ method, and
      # this method serve as a proxy to RSpec +after+ method call. That means
      # everything that we can do inside +after+ method will be available inside
      # +after+ to.
      #
      # @return [Array<RSpec::Core::Hooks::AfterHook>] an array of after hook filter
      def after(&block)
        target.after(&block)
      end
    end
  end
end
