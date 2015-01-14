require 'rails_helper'

include RSpec::Authorization::Adapters

describe Resource do
  let(:privilege) { :privilege }
  let(:resource)  { Resource.new(privilege) }

  subject { resource }

  its(:privilege) { is_expected.to eq privilege }

  specify { is_expected.to delegate_method(:actions).to(:privilege) }
  specify { is_expected.to delegate_method(:negated_actions).to(:privilege) }
  specify { is_expected.to delegate_method(:controller_class).to(:privilege) }
  specify { is_expected.to delegate_method(:role).to(:privilege) }

  describe "#run_all" do
    before do
      expect(resource).to receive(:requests)
      expect(resource).to receive(:negated_requests)
    end

    specify { resource.run_all }
  end

  describe "#permitted?" do
    context "no negated actions" do
      before { allow(resource).to receive(:permitted_for?).and_return(value) }

      context "permitted for actions" do
        let(:value) { true }

        specify { expect(resource.permitted?).to be_truthy }
      end

      context "not permitted for actions" do
        let(:value) { false }

        specify { expect(resource.permitted?).to be_falsy }
      end
    end

    context "have negated actions" do
      before do
        allow(resource).to receive(:negated_results).and_return([:present])
        allow(resource).to receive(:permitted_for?).and_return(permitted_value)
        allow(resource).to receive(:forbidden_for?).and_return(true)
      end

      context "permitted for actions" do
        let(:permitted_value) { true }

        specify { expect(resource.permitted?).to be_truthy }
      end

      context "not permitted for actions" do
        let(:permitted_value) { false }

        specify { expect(resource.permitted?).to be_falsy }
      end
    end
  end

  describe "#forbidden?" do
    context "no negated actions" do
      before { allow(resource).to receive(:forbidden_for?).and_return(value) }

      context "forbidden for actions" do
        let(:value) { true }

        specify { expect(resource.forbidden?).to be_truthy }
      end

      context "not forbidden for actions" do
        let(:value) { false }

        specify { expect(resource.forbidden?).to be_falsy }
      end
    end

    context "have negated actions" do
      before do
        allow(resource).to receive(:negated_results).and_return([:present])
        allow(resource).to receive(:forbidden_for?).and_return(value)
        allow(resource).to receive(:permitted_for?).and_return(true)
      end

      context "forbidden for actions" do
        let(:value) { true }

        specify { expect(resource.forbidden?).to be_truthy }
      end

      context "not forbidden for actions" do
        let(:value) { false }

        specify { expect(resource.forbidden?).to be_falsy }
      end
    end
  end
end
