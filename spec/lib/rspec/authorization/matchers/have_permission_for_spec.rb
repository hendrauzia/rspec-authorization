require 'rails_helper'

include RSpec::Authorization::Matchers::HavePermissionFor

describe HavePermissionFor do
  let(:role)    { :user }
  let(:action)  { :index }
  let(:klass)   { ArticlesController }
  let(:results) { {action => false} }
  let(:matcher) { HavePermissionFor.new(role) }

  before do
    allow(matcher).to receive(:controller).and_return(klass.new)
    allow(matcher).to receive(:results).and_return(results)
  end

  subject { matcher.to(action) }

  its(:role)    { is_expected.to eq role }
  its(:behave)  { is_expected.to eq action }
  its(:actions) { is_expected.to eq [action] }

  its(:description) { is_expected.to eq "have permission for #{role} to #{matcher.behave}" }
  its(:failure_message) { is_expected.to eq "Expected #{klass} to have permission for #{role} to #{matcher.behave}. #{results}" }
  its(:failure_message_when_negated) { is_expected.to eq "Did not expect #{klass} to have permission for #{role} to #{matcher.behave}. #{results}" }

  context "evaluator" do
    before { allow(matcher).to receive(:all_requests).and_return([]) }

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

  context "#method_missing" do
    context "method not implemented" do
      specify { expect{ matcher.to_explode }.to raise_error NoMethodError }
    end

    context "method implemented" do
      specify { expect{ matcher.to_read }.not_to raise_error }
    end
  end

  context "RESTful #to_(behave)" do
    context "#to_read" do
      subject { matcher.to_read }

      its(:behave)  { is_expected.to eq :read }
      its(:actions) { is_expected.to eq %i(index show) }
    end

    context "#to_create" do
      subject { matcher.to_create }

      its(:behave)  { is_expected.to eq :create }
      its(:actions) { is_expected.to eq %i(new create) }
    end

    context "#to_update" do
      subject { matcher.to_update }

      its(:behave)  { is_expected.to eq :update }
      its(:actions) { is_expected.to eq %i(edit update) }
    end

    context "#to_delete" do
      subject { matcher.to_delete }

      its(:behave)  { is_expected.to eq :delete }
      its(:actions) { is_expected.to eq %i(destroy) }
    end

    context "#to_manage" do
      subject { matcher.to_manage }

      its(:behave)  { is_expected.to eq :manage }
      its(:actions) { is_expected.to eq %i(index show new create edit update destroy) }
    end
  end
end
