require 'rails_helper'

include RSpec::Authorization::Adapters

describe Example do
  let(:klass)   { GroupTestClass }
  let(:group)   { ExampleGroup.new(klass) }
  let(:example) { Example.new(group.target) }

  before { allow_any_instance_of(Example).to receive(:run_before_example) }

  subject { example }

  its(:group_target) { is_expected.to eq group.target }
  its(:target)       { is_expected.to be_a_kind_of RSpec::Core::Example }
end
