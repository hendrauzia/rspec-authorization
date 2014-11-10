require 'rails_helper'

include RSpec::Authorization::Adapters

describe ExampleGroup do
  let(:klass)         { ArticlesController }
  let(:example_group) { ExampleGroup.new(klass) }

  let(:before_instruction)   { ->{ :before } }
  let(:after_instruction)    { ->{ :after } }

  describe "target" do
    subject { example_group.target }
    its(:described_class) { is_expected.to eq klass }
  end

  describe "#before" do
    specify { expect(example_group.before(&before_instruction).last.block).to eq before_instruction }
  end

  describe "#after" do
    specify { expect(example_group.after(&after_instruction).first.block).to eq after_instruction }
  end

  describe "#run_example" do
    specify { expect(example_group.run_example).to be_a_kind_of(Example) }
  end
end
