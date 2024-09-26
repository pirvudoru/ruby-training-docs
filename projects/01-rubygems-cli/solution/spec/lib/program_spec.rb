require "spec_helper"
require "./lib/program"
require "./lib/common/error_result"
require "./lib/show/result"
require "./lib/search/result"

RSpec.describe Program do
  subject(:program) { described_class }

  describe ".execute" do
    subject(:execute) { program.execute(argv)}

    context "with non existing command name" do
      let(:argv) { ["non_existing_command"] }

      it "returns Common::ErrorResult" do
        result = execute

        expect(result.class).to be Common::ErrorResult
        expect(result.error_message).to eq "Invalid command."
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with nil command name" do
      let(:argv) { [nil] }

      it "returns Common::ErrorResult" do
        result = execute
        
        expect(result.class).to be Common::ErrorResult
        expect(result.error_message).to eq "Invalid command."
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with empty command name" do
      let(:argv) { [""] }

      it "returns Help::Result" do
        result = execute
        
        expect(result.class).to be Common::ErrorResult
        expect(result.error_message).to eq "Invalid command."
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with empty argv array" do
      let(:argv) { [] }

      it "returns Common::ErrorResult" do
        result = execute
        
        expect(result.class).to be Common::ErrorResult
        expect(result.error_message).to eq "Invalid command."
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with show existing gem" do
      let(:argv) { ["show", "rspec"] }

      it "returns Show::Result" do
        result = execute

        expect(result.class).to be Show::Result
        expect(result.gem_name).to eq "rspec"
        expect(result.info).to eq "BDD for Ruby"
        expect(result.exit_code).to eq 0
      end
    end

    context "with show inexisting gem" do
      let(:argv) { ["show", "non_existing_gem"] }

      it "returns Common::ErrorResult" do
        result = execute

        expect(result.class).to be Common::ErrorResult
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with show command but multiple arguments" do
      let(:argv) { ["show", "rspec", "sinatra", "rails"] }

      it "returns Common::ErrorResult" do
        result = execute

        expect(result.class).to be Common::ErrorResult
        expect(result.exit_code).not_to eq 0
      end
    end

    context "with search valid keyword" do
      let(:argv) { ["search", "rspec"] }

      it "returns Search::Result" do
        result = execute

        expect(result.class).to be Search::Result
        expect(result.gems.size).not_to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search invalid keyword" do
      let(:argv) { ["search", "non_existing_gem"] }

      it "raises Search::Result" do
        result = execute

        expect(result.class).to be Search::Result
        expect(result.gems.class).to be Array
        expect(result.gems.size).to eq 0
        expect(result.exit_code).to eq 0
      end
    end

    context "with search command but multiple arguments", skip: true do
      let(:argv) { ["search", "rspec", "sinatra", "rails"] }

      it "returns Search::Result for the first argument" do
        result = execute

        expect(result.class).to be Common::ErrorResult
        expect(result.exit_code).not_to eq 0
      end
    end

    context 'with --most-downloads-first option' do
      let(:argv) { ["search", "rspec", "--most-downloads-first"] }

      it "returns Search::Result and gems ordered by downloads" do
        result = execute

        expect(result.gems.each_cons(2).all? { |a, b| a.downloads > b.downloads }).to be true
      end
    end

    context 'with --license option' do
      let(:argv) { ["search", "rspec", "--license", "MIT"] }

      it "returns Search::Result and specified license" do
        result = execute

        expect(result.gems.all? { |a| a.license?('MIT') }).to be true
      end
    end
  end
end
