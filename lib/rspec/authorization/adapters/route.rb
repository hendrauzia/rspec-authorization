module RSpec::Authorization
  module Adapters
    class Route
      attr_reader :action

      DICTIONARIES = {
        index:   :get,
        show:    :get,
        new:     :get,
        create:  :post,
        edit:    :get,
        update:  :patch,
        destroy: :delete
      }

      PARAMS = {
        show:    { id: 1 },
        edit:    { id: 1 },
        update:  { id: 1 },
        destroy: { id: 1 }
      }

      def initialize(action)
        @action = action
      end

      def params
        PARAMS[action]
      end

      def verb
        DICTIONARIES.fetch(action)
      end

      def to_a
        [verb, action, params]
      end
    end
  end
end
