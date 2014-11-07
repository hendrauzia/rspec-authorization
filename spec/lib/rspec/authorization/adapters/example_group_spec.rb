require 'rails_helper'

include RSpec::Authorization::Adapters

describe ExampleGroup do
  let(:klass)         { PostsController }
  let(:instruction)   { ->{} }
  let(:example_group) { ExampleGroup.new(klass) }

  describe "target" do
    subject { example_group.target }
    its(:described_class) { is_expected.to eq klass }
  end

  describe "#push" do
    specify { expect(example_group.push(&instruction).last.block).to eq instruction }
  end

  describe "#run_example" do
    specify { expect(example_group.run_example).to be_a_kind_of(Example) }
  end
end
