module RSpec::Authorization
  module Adapters
    # Generate route that defines RESTful method using provided action. It is
    # used primarily in creating a new request and infered automatically to an
    # array using the defined +#to_a+ method.
    #
    # Route generation has 3 primary part, which are:
    # - +verb+
    # - +action+
    # - +params+
    #
    # The first part, +verb+ refers to RESTful method, which is described in
    # +DICTIONARIES+, +action+ refers to controller action name, and +params+
    # refers to parameters used in a request. This object can be automatically
    # inferred as an array.
    #
    # Creating a route will generate a route object:
    # 
    #   route = Route.new(:index)
    #   route # => #<Route:...>
    #
    # This will infer the object as an array:
    #
    #   route = Route.new(:show)
    #   send *route # => [:get, :show, { id: 1 }]
    #
    # @see #to_a
    class Route
      # @return [Symbol] returns route action name
      attr_reader :action

      # Initializing a route requires a RESTful action name that the route want
      # to generate. The action that get passed is assigned to +action+ attributes
      # and is publicly accessible.
      #
      #   route = Route.new(:index)
      #   route.action # => :index
      #
      # Currently +Route+ only support RESTful action, passing non-RESTful action
      # name is possible, but will result in unexpected result.
      #
      # @param action [Symbol] RESTful action name
      # @see #verb
      def initialize(action)
        @action = action
      end

      # This method is used to retrieve a dummy params that's used for an action.
      # Tipically an action for a resource member requires a param, while action
      # for resource collection doesn't need any param.
      #
      # This will return a dummy params:
      #
      #   route = Route.new(:show)
      #   route.params # => { id: 1 }
      #
      # This will return nil for a collection resource action:
      #
      #   route = Route.new(:index)
      #   route.params # => nil
      #
      # @return [Hash, nil] a dummy hash params
      def params
        PARAMS[action]
      end

      # Return verb used for the RESTful action. The verb uses +DICTIONARIES+ to
      # retrieve a valid method for an action. This method intentionally throws
      # error if a non-RESTful action is used.
      #
      #   route = Route.new(:index)
      #   route.verb # => :get
      #
      # This will throw error:
      #
      #   route = Route.new(:an_action)
      #   route.verb # => KeyError: key not found: :an_action
      #
      # @return [Symbol] RESTful verb to be used for an action
      def verb
        DICTIONARIES.fetch(action)
      end

      # This method is used to convert Route object into an array. This method also
      # used to automatically infer +Route+ as an array on method that uses +to_a+,
      # therefore we don't need to manually invoke +#to_a+ on every call that
      # requires an array object.
      #
      # This will return an array:
      #
      #   route = Route.new(:show)
      #   route.to_a # => [:get, :show, { id: 1 }]
      #
      # This will also return an array inferred automatically
      #
      #   send *route # => [:get, :show, { id: 1 }]
      #
      # @return [Array] an array of verb, action and params
      def to_a
        [verb, action, params]
      end

      private

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
    end
  end
end
