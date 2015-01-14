module RSpec::Authorization
  module Adapters
    class Privilege # :nodoc:
      attr_reader :actions, :negated_actions, :controller_class, :role

      def initialize(**params)
        @actions          = params[:actions]
        @negated_actions  = params[:negated_actions]
        @controller_class = params[:controller_class]
        @role             = params[:role]
      end
    end
  end
end
