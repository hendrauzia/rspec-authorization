require 'rails_helper'

include RSpec::Authorization::Adapters

describe Resource do
  let(:resource) { Resource.new }

  describe "#restful_helper_method=" do
    before { resource.restful_helper_method = "to_read" }

    specify { expect(resource.restful_helper_method).to be_a_kind_of(RestfulHelperMethod) }
  end

  describe "#actions" do
    context "restful helper method undefined" do
      let(:actions) { %i(list of actions) }

      before { resource.actions = actions }

      specify { expect(resource.actions).to eq actions }
    end

    context "restful helper method defined" do
      before { resource.restful_helper_method = 'to_read' }

      specify { expect(resource.actions).to eq %i(index show) }
    end
  end

  describe "#negated_actions" do
    context "restful helper method undefined" do
      let(:negated_actions) { %i(list of negated actions) }

      before { resource.negated_actions = negated_actions }

      specify { expect(resource.negated_actions).to eq negated_actions }
    end

    context "restful helper method defined" do
      before { resource.restful_helper_method = 'except_to_read' }

      specify { expect(resource.negated_actions).to eq %i(index show) }
    end
  end
end
