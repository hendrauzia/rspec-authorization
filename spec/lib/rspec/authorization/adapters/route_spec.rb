require 'rails_helper'

include RSpec::Authorization::Adapters

describe Route do
  let(:route)  { Route.new(:action) }

  subject { route }
  its(:action) { is_expected.to eq :action }

  describe "#params" do
    def param_of(action)
      Route.new(action).params
    end

    context "without params" do
      context "index" do
        specify { expect(param_of(:index)).not_to be_present }
      end

      context "new" do
        specify { expect(param_of(:new)).not_to be_present }
      end

      context "create" do
        specify { expect(param_of(:create)).not_to be_present }
      end
    end

    context "with params" do
      context "show" do
        specify { expect(param_of(:show)).to be_present }
      end

      context "edit" do
        specify { expect(param_of(:edit)).to be_present }
      end

      context "update" do
        specify { expect(param_of(:update)).to be_present }
      end

      context "destroy" do
        specify { expect(param_of(:destroy)).to be_present }
      end
    end
  end

  describe "#verb" do
    def verb_of(action)
      Route.new(action).verb
    end

    context "RESTful routes" do
      context "index" do
        specify { expect(verb_of(:index)).to eq :get }
      end

      context "show" do
        specify { expect(verb_of(:show)).to eq :get }
      end

      context "new" do
        specify { expect(verb_of(:new)).to eq :get }
      end

      context "create" do
        specify { expect(verb_of(:create)).to eq :post }
      end

      context "edit" do
        specify { expect(verb_of(:edit)).to eq :get }
      end

      context "update" do
        specify { expect(verb_of(:update)).to eq :patch }
      end

      context "detroy" do
        specify { expect(verb_of(:destroy)).to eq :delete }
      end
    end
  end

  describe "#to_a" do
    before do
      allow(route).to receive(:verb).and_return(:verb)
      allow(route).to receive(:action).and_return(:action)
      allow(route).to receive(:params).and_return(:params)
    end

    specify { expect(route.to_a).to eq [:verb, :action, :params] }
  end
end
