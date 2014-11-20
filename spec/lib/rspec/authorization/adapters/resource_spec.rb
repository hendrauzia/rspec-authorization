require 'rails_helper'

include RSpec::Authorization::Adapters

describe Resource do
  let(:resource) { Resource.new }

  describe "#restful_helper_method=" do
    before  { resource.restful_helper_method = "to_read" }
    specify { expect(resource.restful_helper_method).to be_a_kind_of(RestfulHelperMethod) }
  end
end
