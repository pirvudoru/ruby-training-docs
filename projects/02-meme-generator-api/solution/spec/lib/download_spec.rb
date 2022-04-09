require './lib/download'

RSpec.describe Download do
  describe '.download_image' do
    let(:url) { 'https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg'}

    subject(:download) { Download.download_image(url) }

    it 'saves the file locally' do
      expect(File.exist?(download)).to be true
    end

    context 'bad url for photos' do
      let(:url) { 'sdwqjksad' }

      it 'raises error' do
        expect { download }.to raise_error Download::Error
      end
    end
  end
end