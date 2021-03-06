require 'rails_helper'

include RSpec::Authorization::Adapters
include RSpec::Authorization::Matchers::HavePermissionFor

describe HavePermissionFor do
  let(:role)    { :user }
  let(:action)  { :index }
  let(:klass)   { ArticlesController }
  let(:results) { {action => false} }
  let(:matcher) { HavePermissionFor.new(role) }

  let(:privilege) do
    Privilege.new(
      actions: [action],
      negated_actions: [],
      role: role,
      controller_class: klass
    )
  end

  let(:resource) do
    r = Resource.new(privilege)
    allow(r).to receive(:controller_class).and_return(klass)
    r
  end

  before do
    allow_any_instance_of(Resource).to receive(:results).and_return(results)
    allow(matcher).to receive(:resource).and_return(resource)
  end

  subject { matcher.to(action) }

  its(:role) { is_expected.to eq role }
  its(:description) { is_expected.to eq "have permission for #{role} to #{matcher.action}" }
  its(:failure_message) { is_expected.to eq "Expected #{klass} to have permission for #{role} to #{matcher.action}. results: #{results}, negated_results: " }
  its(:failure_message_when_negated) { is_expected.to eq "Did not expect #{klass} to have permission for #{role} to #{matcher.action}. results: #{results}, negated_results: " }

  context "evaluator" do
    before { allow_any_instance_of(Resource).to receive(:requests).and_return([]) }

    describe "#matches?" do
      context "all requests permitted" do
        let(:results) {{index: true, show: true}}

        specify { expect(matcher.matches?(double)).to be_truthy }
      end

      context "one of the request is forbidden" do
        let(:results) {{index: false, show: true}}

        specify { expect(matcher.matches?(double)).to be_falsy }
      end
    end

    describe "#does_not_match?" do
      context "all requests forbidden" do
        let(:results) {{index: false, show: false}}

        specify { expect(matcher.does_not_match?(double)).to be_truthy }
      end

      context "one of the request is permitted" do
        let(:results) {{index: false, show: true}}

        specify { expect(matcher.does_not_match?(double)).to be_falsy }
      end
    end
  end

  describe "#method_missing" do
    context "method not implemented" do
      specify { expect{ matcher.to_explode }.to raise_error NoMethodError }
    end

    context "method implemented" do
      specify { expect{ matcher.to_read }.not_to raise_error }
    end
  end
end
