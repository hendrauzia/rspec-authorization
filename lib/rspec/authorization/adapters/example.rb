module RSpec::Authorization
  module Adapters
    class Example
      attr_reader :group, :example

      def initialize(group)
        @group   = group
        @example = RSpec::Core::Example.new(group, "", {})

        set_example_group_instance
      end

      def run
        run_before_example
      end

      private

      def set_example_group_instance
        @example.instance_variable_set :@example_group_instance, group.new
      end

      def run_before_example
        @example.send :run_before_example
      end
    end
  end
end
