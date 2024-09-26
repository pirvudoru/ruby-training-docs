require "spec_helper"
require "./lib/show/command"

RSpec.describe Show::Command do
  subject(:program) { described_class }

  describe ".execute" do
    subject(:execute) { program.execute(arg) }

    context "with existing gem" do
      let(:arg) { ["rspec"] }

      it "returns Show::Result" do
        result = execute

        expect(result.class).to be Show::Result
      end
    end
  end
end
