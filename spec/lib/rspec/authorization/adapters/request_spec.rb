require 'rails_helper'

include RSpec::Authorization::Adapters

describe Request do
  let(:klass)   { ArticlesController }
  let(:action)  { :update }
  let(:role)    { :editor }
  let(:request) { Request.new(klass, action, role) }

  subject { request }

  its(:klass)  { is_expected.to eq klass }
  its(:action) { is_expected.to eq action }
  its(:role)   { is_expected.to eq role }

  context "private" do
    describe "#response_setter" do
      let(:response_setter) { request.send :response_setter }

      before { response_setter.call(:response) }

      its(:response) { is_expected.to eq :response }
    end

    describe "#role_symbols" do
      specify { expect(request.send(:role_symbols)).to include role }
    end
  end
end
