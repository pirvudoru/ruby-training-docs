require "spec_helper"
require './lib/common/cache'

RSpec.describe Common::Cache do
  describe '#read' do
    let(:instance) { described_class.create }
    let(:key) { 'my-unique-key' }

    subject(:read) { instance.read(key) }

    after :each do
      instance.clear
    end

    it { is_expected.to be nil }

    context 'when a value has been written' do
      let(:value) { '42' }

      before :each do
        instance.write(key, value)
      end

      it { is_expected.to eq value }
    end

    context 'when a value has expired' do
      let(:value) { '42' }

      before :each do
        instance.write(key, value, Time.now - 49 * 60 * 60)
      end

      it { is_expected.to be nil }
    end
  end
end