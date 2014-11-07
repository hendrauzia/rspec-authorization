module RSpec::Authorization
  module Adapters
    # Wrapper to generate and immediately run example from +RSpec::Core::Example+.
    # The purpose of this class is to abstract running of an example without
    # unnecessary artifacts from an RSpec's example, such as: reporting, context
    # and expectation.
    #
    # The sole purpose of this class is to generate the most minimum required
    # variable to create and run example, for our matcher to run against. The
    # trick to run the example without producing unnecessary artifacts is to
    # trigger +target#run_before_example+.
    class Example
      # @return [Class] target of +ExampleGroup+ class
      attr_reader :group_target
      # @return [RSpec::Core::Example] instance of RSpec's example
      attr_reader :target

      # @param group_target [Class] retrieved from ExampleGroup#target
      # @see ExampleGroup
      def initialize(group_target)
        @group_target = group_target
        @target       = RSpec::Core::Example.new(group_target, "", {})

        set_example_group_instance
        run_before_example
      end

      private

      def set_example_group_instance
        target.instance_variable_set :@example_group_instance, group_target.new
      end

      def run_before_example
        target.send :run_before_example
      end
    end
  end
end
