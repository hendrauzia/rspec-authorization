module RSpec::Authorization
  module Adapters
    class Group
      class << self
        def new(klass)
          RSpec::Core::ExampleGroup.describe klass do
            include RSpec::Rails::ControllerExampleGroup
          end
        end
      end
    end
  end
end

