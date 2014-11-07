module RSpec::Authorization
  module Adapters
    # Wrapper to generate +RSpec::Core::ExampleGroup+. The example group
    # includes +RSpec::Rails::ControllerExampleGroup+ to add behavior testing,
    # which provides methods to test the controller, such as: +get+, +post+,
    # +patch+, +put+ and +delete+.
    #
    # Consider the following example:
    #
    #   group = ExampleGroup.new(PostsController)
    #   group.target # => RSpec::ExampleGroups::PostsController
    #
    # Instantiating the class for a second time produce a different result:
    #
    #   group = ExampleGroup.new(PostsController)
    #   group.target # => RSpec::ExampleGroups::PostsController_2
    class ExampleGroup
      # @return [Class] a class namespaced from +RSPec::ExampleGroups+
      attr_reader :target

      # @param klass [Class] class for an example group
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

      # Pushes instruction to be run before our example. Instructions to be pushed
      # will be run inside the context of our example group, consider the following
      # example:
      #
      #   push do
      #     get :index
      #   end
      #
      # The above statements will result in pushing +get :index+ to be run before
      # our example. This is analogous to the way RSpec's +before+ method call, in
      # fact, it simply serve as an alias to it, consider the following example:
      #
      #   # inside an rspec's spec file
      #   before do
      #     get :index
      #   end
      #
      # The above statements behave exactly the same and this method serve as a proxy
      # to RSpec +before+ method call for convinience. That means everything that we
      # can do inside +before+ method will be available inside +push+ to.
      #
      # @return [Array<RSpec::Core::Hooks::BeforeHook>] an array of before hook filter
      def push(&block)
        target.before(&block)
      end
    end
  end
end
