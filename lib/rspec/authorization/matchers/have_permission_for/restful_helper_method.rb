module RSpec::Authorization
  module Matchers
    module HavePermissionFor
      # Create a new restful helper method using the available dictionaries. Method
      # that is not available raise a +NoMethodError+, consider the following
      # example:
      #
      #   RestfulHelperMethod.new(:to_read)
      #
      # Currently available helper method are:
      #
      # - +to_read+
      # - +to_create+
      # - +to_update+
      # - +to_delete+
      # - +to_manage+
      #
      # The above method is not related to declarative_authorization privileges,
      # and serve simply as convinience method, below is a table of restful actions
      # returned from the restful helper method:
      #
      #   Method         RESTful action
      #   ------------------------------------
      #   to_read       [:index, :show]
      #   to_create     [:new, :create]
      #   to_update     [:edit, :update]
      #   to_delete     [:destroy]
      #   to_manage     [:index, :show, :new, :create, :edit, :update, :destroy]
      #
      # This class can be inferred automatically as an array, for example on
      # multiple assignment, consider the following example:
      #
      #   behavior, actions = RestfulHelperMethod(:to_read)
      #   behavior # => :read
      #   actions  # => [:index, :show]
      #
      class RestfulHelperMethod
        # [Symbol] Restful helper method name
        attr_reader :name
        # [Symbol] The behavior of the restful helper method
        attr_reader :behavior
        # [Symbol] The list of action for a given behavior
        attr_reader :actions

        # Creates a restful helper method using the available dictionaries. Invalid
        # or a non-available helper method that passed in raise an error, consider
        # the following example:
        #
        #   RestfulHelperMethod.new(:to_explode) # this will explode
        #   => NoMethodError: undefined method `to_explode' for RestfulHelperMethod
        #
        # @param name [Symbol] restful method name to be retrieved
        def initialize(name)
          @name     = name.to_sym
          @behavior = /^to_(.*)$/.match(name)[1].to_sym
          @actions  = DICTIONARIES[behavior]

          raise NoMethodError, "undefined method `#{name}' for #{self.class}" unless DICTIONARIES.key?(@behavior)
        end

        private

        def to_ary
          [behavior, actions]
        end

        DICTIONARIES = {
          read:   %i(index show),
          create: %i(new create),
          update: %i(edit update),
          delete: %i(destroy),
          manage: %i(index show new create edit update destroy)
        }
      end
    end
  end
end
