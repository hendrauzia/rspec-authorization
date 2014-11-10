module RSpec::Authorization
  module Adapters
    # Wrapper to generate and immediately run example from +RSpec::Core::Example+.
    # The purpose of this class is to abstract the running of an example without
    # unnecessary artifacts from an RSpec example, such as: reporter, generated
    # description, context and expectation.
    #
    # The sole purpose of this class is to generate the minimum required component
    # needed to create and run an example, for our matcher to run against. The trick
    # to run the example without producing unnecessary artifacts is to trigger
    # the example's before and after hook manually without running any expectations.
    class Example
      # @return [Class] RSpec example group
      attr_reader :group_target
      # @return [RSpec::Core::Example] instance of RSpec example
      attr_reader :target

      # Initialize example using RSpec example group. The RSpec example group can
      # be retrieved using example group's target, consider the following example:
      #
      #   group   = ExampleGroup.new(ArticlesController)
      #   example = Example.new(group.target)
      #
      # @param group_target [Class] RSpec example group from +ExampleGroup#target+
      # @see ExampleGroup#target
      def initialize(group_target)
        @group_target = group_target
        @target       = RSpec::Core::Example.new(group_target, "", {})

        set_example_group_instance
        run_before_example
        run_after_example
      end

      private

      def set_example_group_instance
        target.instance_variable_set :@example_group_instance, group_target.new
      end

      def run_before_example
        target.send :run_before_example
      end

      def run_after_example
        target.example_group.hooks.run(:after, :example, target)
        target.example_group_instance.teardown_mocks_for_rspec
      end
    end
  end
end
