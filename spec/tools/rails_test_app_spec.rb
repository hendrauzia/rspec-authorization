require 'spec_helper'
require 'rails_test_app'

describe RailsTestApp do
  let(:test_app)   { RailsTestApp.new(:version) }
  let(:dummy_file) { 'tmp/dummy-rails-test-app' }

  describe ".new" do
    subject(:test_app) { RailsTestApp.new("4.1.6", "--skip-javascript") }

    its(:path)    { is_expected.to include("4.1.6") }
    its(:options) { is_expected.to include("--skip-javascript") }
    its(:create_command)  { is_expected.to include("4.1.6") }
    its(:destroy_command) { is_expected.to include("4.1.6") }
  end

  describe "#create" do
    before { allow(test_app).to receive(:create_command).and_return("touch #{dummy_file}") }
    before { allow(test_app).to receive(:option) }
    after  { `rm -rf #{dummy_file}` }

    context "path does not exists" do
      before { allow(test_app).to receive(:exists?).and_return(false) }

      it { expect(test_app.create).to be_truthy }
    end

    context "path exists" do
      before { allow(test_app).to receive(:exists?).and_return(true) }

      it { expect(test_app.create).to be_falsy }
    end
  end

  describe "#destroy" do:w
    before { `touch #{dummy_file}` }
    before { allow(test_app).to receive(:destroy_command).and_return("rm -rf #{dummy_file}") }

    context "path does not exists" do
      before { allow(test_app).to receive(:exists?).and_return(false) }

      it { expect(test_app.destroy).to be_falsy }
    end

    context "path exists" do
      before { allow(test_app).to receive(:exists?).and_return(true) }

      it { expect(test_app.destroy).to be_truthy }
    end
  end

  describe "#exists?" do
    let(:spec_path) { "spec/" }
    let(:void_path) { "does-not-exists" }

    context "path does not exists" do
      before { allow(test_app).to receive(:path).and_return(void_path) }

      it { expect(test_app.exists?).to be_falsy }
    end

    context "path exists" do
      before { allow(test_app).to receive(:path).and_return(spec_path) }

      it { expect(test_app.exists?).to be_truthy }
    end
  end

  describe "#option" do
    let(:options) { %i(a b) }
    before { allow(test_app).to receive(:options).and_return(options) }

    it { expect(test_app.option).to eq("a b") }
  end
end
