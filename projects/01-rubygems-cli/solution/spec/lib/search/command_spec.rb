require "spec_helper"
require "./lib/search/command"
require "./lib/search/result"

RSpec.describe Search::Command do
  subject(:program) { described_class }

  describe ".execute" do
    subject(:execute) { program.execute(arg) }

    context "with valid keyword" do
      let(:arg) { ["rspec"] }

      it "returns Search::Result" do
        result = execute

        expect(result.class).to be Search::Result
      end
    end
  end
end
