require 'rails_helper'

include RSpec::Authorization::Adapters

describe Resource do
  let(:klass)    { ArticlesController }
  let(:actions)  { %i(list of action) }
  let(:role)     { :role }
  let(:results)  {{ index: true, show: false }}
  let(:resource) { Resource.new(klass, actions, role) }

  before  { allow_any_instance_of(Resource).to receive(:run_requests).and_return(results) }
  subject { resource }

  its(:klass)   { is_expected.to eq klass }
  its(:actions) { is_expected.to eq actions }
  its(:role)    { is_expected.to eq role }
  its(:results) { is_expected.to eq results }
end
