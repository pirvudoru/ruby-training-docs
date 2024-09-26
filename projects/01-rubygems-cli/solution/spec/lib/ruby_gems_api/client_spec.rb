require "spec_helper"
require "./lib/ruby_gems_api/client"

RSpec.describe RubyGemsApi::Client do
  subject(:api) { described_class }

  describe ".gem_info" do
    subject(:gem_info) { api.gem_info(gem_name) }

    context "with existing gem" do
      let(:gem_name) { "rspec" }
      it "returns rpsec info" do
        result = gem_info
        expect(result.name).to eq "rspec"
        expect(result.info).to eq "BDD for Ruby"
      end
    end

    context "with non existing gem" do
      let(:gem_name) { "not_existing_gem" }
      it "raises GemNotFoundError" do
        expect { gem_info }.to raise_error(RubyGemsApi::GemNotFoundError)
      end
    end

    context "with gem name empty" do
      let(:gem_name) { "" }
      it "raises ArgumentError" do
        expect { gem_info }.to raise_error(ArgumentError)
      end
    end

    context "with gem name nil" do
      let(:gem_name) { nil }
      it "raises ArgumentError" do
        expect { gem_info }.to raise_error(ArgumentError)
      end
    end

    context "with Ruby Gems webserver down or API problems" do
      let(:gem_name) { "it_does_not_matter" }
      it "raises StandardAPIError on failed request", :skip do
        # TODO: Mock RubyGems webserver
        expect { gem_info }.to raise_error(RubyGemsApi::StandardAPIError)
      end
    end
  end

  describe ".search_gems" do
    subject(:search_gems) { api.search_gems(keyword) }

    context "with keyword valid" do
      let(:keyword) { "rspec" }
      it "returns a non empty array of json objects" do
        result = search_gems
        expect(result.class).to be Array
        expect(result.size).not_to eq 0

        expect(result.first.name).to eq 'rspec'
        expect(result.first.info).to eq "BDD for Ruby"
      end
    end

    context "with keyword invalid" do
      let(:keyword) { "not_existing_gem" }
      it "returns an empty array" do
        result = search_gems
        expect(result.class).to be Array
        expect(result.size).to eq 0
      end
    end

    context "with keyword empty" do
      let(:keyword) { "" }
      it "raises ArgumentError" do
        expect { search_gems }.to raise_error(ArgumentError)
      end
    end

    context "with keyword nil" do
      let(:keyword) { nil }
      it "raises ArgumentError" do
        expect { search_gems }.to raise_error(ArgumentError)
      end
    end

    context "with Ruby Gems webserver down or API problems" do
      let(:gem_name) { "it_does_not_matter" }
      it "raises StandardAPIError on failed request", :skip do
        # TODO: Mock RubyGems webserver
        expect { gem_info }.to raise_error(RubyGemsApi::StandardAPIError)
      end
    end
  end
end
