require './lib/download'

RSpec.describe Download do
  describe '.download_image' do
    let(:url) { 'https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg'}

    subject(:download) { Download.download_image(url) }

    it { is_expected.to eq File.basename(url) }

    context 'bad url for photos' do
      let(:url) { 'sdwqjksad' }

      it { is_expected.to be nil }
    end
  end
end