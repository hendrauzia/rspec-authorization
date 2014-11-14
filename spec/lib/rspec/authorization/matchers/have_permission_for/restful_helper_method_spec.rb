require 'rails_helper'

include RSpec::Authorization::Matchers::HavePermissionFor

describe RestfulHelperMethod do
  let(:restful_helper_method) { RestfulHelperMethod.new(name) }
  subject { restful_helper_method }

  describe "#to_ary" do
    let(:name)    { :to_read }
    let(:actions) { %i(list of action from actions) }

    before do
      allow(restful_helper_method).to receive(:behavior).and_return(:behavior)
      allow(restful_helper_method).to receive(:actions).and_return(actions)
    end

    context "implicitly infers to array" do
      before  { @behavior, @actions = restful_helper_method }

      specify { expect([@behavior, @actions]).to eq [:behavior, actions] }
    end
  end

  context "method unavailable" do
    specify { expect{ RestfulHelperMethod.new(:to_explode) }.to raise_error NoMethodError }
  end

  context "method available" do
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
end
