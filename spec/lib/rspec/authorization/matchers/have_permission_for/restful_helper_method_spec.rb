require 'rails_helper'

include RSpec::Authorization::Matchers::HavePermissionFor

describe RestfulHelperMethod do
  let(:restful_helper_method) { RestfulHelperMethod.new(name) }
  subject { restful_helper_method }

  describe "#to_ary" do
    let(:name)    { :to_read }
    let(:actions) { %i(list of action from actions) }
    let(:negated_actions) { %i(list of negated action from negated_actions) }

    before do
      allow(restful_helper_method).to receive(:prefix).and_return(:prefix)
      allow(restful_helper_method).to receive(:behavior).and_return(:behavior)
      allow(restful_helper_method).to receive(:actions).and_return(actions)
      allow(restful_helper_method).to receive(:negated_actions).and_return(negated_actions)
    end

    context "implicitly infers to array" do
      before  { @prefix, @behavior, @actions, @negated_actions = restful_helper_method }

      specify { expect([@prefix, @behavior, @actions, @negated_actions]).to eq [:prefix, :behavior, actions, negated_actions] }
    end
  end

  context "method unavailable" do
    specify { expect{ RestfulHelperMethod.new(:to_explode) }.to raise_error NoMethodError }
  end

  context "restful methods" do
    let(:name)   { :to_read }
    its(:prefix) { is_expected.to eq :to }
    its(:negated_actions) { is_expected.to eq %i() }

    context "to_read" do
      let(:name) { :to_read }

      its(:behavior) { is_expected.to eq :read }
      its(:actions)  { is_expected.to eq %i(index show) }
    end

    context "to_create" do
      let(:name) { :to_create }

      its(:behavior) { is_expected.to eq :create }
      its(:actions)  { is_expected.to eq %i(new create) }
    end

    context "to_update" do
      let(:name) { :to_update }

      its(:behavior) { is_expected.to eq :update }
      its(:actions)  { is_expected.to eq %i(edit update) }
    end

    context "to_delete" do
      let(:name) { :to_delete }

      its(:behavior) { is_expected.to eq :delete }
      its(:actions)  { is_expected.to eq %i(destroy) }
    end

    context "to_manage" do
      let(:name) { :to_manage }

      its(:behavior) { is_expected.to eq :manage }
      its(:actions)  { is_expected.to eq %i(index show new create edit update destroy) }
    end
  end

  context "focused restful methods" do
    context "only_to" do
      let(:name)   { :only_to_read }
      its(:prefix) { is_expected.to eq :only_to }

      context "only_to_read" do
        let(:name) { :only_to_read }

        its(:behavior) { is_expected.to eq :read }
        its(:actions)  { is_expected.to eq %i(index show) }
        its(:negated_actions) { is_expected.to eq %i(new create edit update destroy) }
      end

      context "only_to_create" do
        let(:name) { :only_to_create }

        its(:behavior) { is_expected.to eq :create }
        its(:actions)  { is_expected.to eq %i(new create) }
        its(:negated_actions) { is_expected.to eq %i(index show edit update destroy) }
      end

      context "only_to_update" do
        let(:name) { :only_to_update }

        its(:behavior) { is_expected.to eq :update }
        its(:actions)  { is_expected.to eq %i(edit update) }
        its(:negated_actions) { is_expected.to eq %i(index show new create destroy) }
      end

      context "only_to_delete" do
        let(:name) { :only_to_delete }

        its(:behavior) { is_expected.to eq :delete }
        its(:actions)  { is_expected.to eq %i(destroy) }
        its(:negated_actions) { is_expected.to eq %i(index show new create edit update) }
      end
    end

    context "except_to" do
      let(:name)   { :except_to_read }
      its(:prefix) { is_expected.to eq :except_to }

      context "except_to_read" do
        let(:name) { :except_to_read }

        its(:behavior) { is_expected.to eq :read }
        its(:actions)  { is_expected.to eq %i(new create edit update destroy) }
        its(:negated_actions) { is_expected.to eq %i(index show) }
      end

      context "except_to_create" do
        let(:name) { :except_to_create }

        its(:behavior) { is_expected.to eq :create }
        its(:actions)  { is_expected.to eq %i(index show edit update destroy) }
        its(:negated_actions) { is_expected.to eq %i(new create) }
      end

      context "except_to_update" do
        let(:name) { :except_to_update }

        its(:behavior) { is_expected.to eq :update }
        its(:actions)  { is_expected.to eq %i(index show new create destroy) }
        its(:negated_actions) { is_expected.to eq %i(edit update) }
      end

      context "except_to_delete" do
        let(:name) { :except_to_delete }

        its(:behavior) { is_expected.to eq :delete }
        its(:actions)  { is_expected.to eq %i(index show new create edit update) }
        its(:negated_actions) { is_expected.to eq %i(destroy) }
      end
    end
  end
end
