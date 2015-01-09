require 'rails_helper'

include RSpec::Authorization::Adapters

describe Resource do
  let(:resource) { Resource.new }

  describe "#run_all" do
    before do
      expect(resource).to receive(:requests)
      expect(resource).to receive(:negated_requests)
    end

    it { resource.run_all }
  end
end
