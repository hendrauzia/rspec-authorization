module RSpec::Authorization
  module Adapters
    class Example
      attr_reader :group, :target

      def initialize(group_target)
        @group  = group_target
        @target = RSpec::Core::Example.new(group, "", {})

        set_example_group_instance
        run_before_example
      end

      private

      def set_example_group_instance
        target.instance_variable_set :@example_group_instance, group.new
      end

      def run_before_example
        target.send :run_before_example
      end
    end
  end
end
