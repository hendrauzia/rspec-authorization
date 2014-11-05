require 'rails_helper'

include RSpec::Authorization::Adapters

describe Group do
  let(:klass) { GroupTestClass }
  let(:group) { Group.new(klass) }

  describe ".new" do
    subject { group }
    its(:described_class) { is_expected.to eq GroupTestClass }
  end
end
