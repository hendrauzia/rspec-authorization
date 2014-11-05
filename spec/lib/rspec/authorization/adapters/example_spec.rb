require 'rails_helper'

include RSpec::Authorization::Adapters

describe Example do
  let(:klass)   { GroupTestClass }
  let(:group)   { Group.new(klass) }
  let(:example) { Example.new(group) }

  subject { example }

  its(:group)   { is_expected.to eq group }
  its(:example) { is_expected.to be_a_kind_of RSpec::Core::Example }

  context "private" do
    describe "#set_example_group_instance" do
      before { example.send :set_example_group_instance }
      specify { expect(example.example.instance_variable_get :@example_group_instance).to be_a_kind_of group }
    end

    describe "#run_before_example" do
      before { expect(example.example).to receive(:run_before_example).and_return(true) }
      specify { expect(example.example.send :run_before_example).to be_present }
    end
  end
end
