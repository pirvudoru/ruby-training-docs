require './lib/validator'

RSpec.describe Download do
  describe '.download_image' do
    context 'validate request body for image' do
      let(:body) { }
      subject(:image_validation) { Validator.validate_image(body)) }

      it 'with good body request' do
        expect(image_validation).to be true
      end
  
    end
    context 'bad url for photos' do
      let(:url) { 'sdwqjksad' }

      it 'raises error' do
        expect { download }.to raise_error Download::Error
      end
    end
  end
end