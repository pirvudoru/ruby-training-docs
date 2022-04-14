require './lib/validators/meme_validator'

RSpec.describe MemeValidator do
  describe '.validate_image' do
    context 'validate request body for image' do
      let(:body) { JSON.parse("{
        \"meme\": {
          \"image_url\": \"https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg\",
          \"text\": \"You got Rick-rolled\"
        }
      }")
    }
      subject(:image_validation) { MemeValidator.validate_image(body) }

      it 'with good body request' do
        expect(image_validation).to eq true
      end
  
    end
    context 'with one bad body parameter' do
      let(:body) { JSON.parse('{
        "meme": {
          "i": "",
          "text": "You got Rick-rolled"
        }
      }') }
      subject(:image_validation) { MemeValidator.validate_image(body) }

      it 'raises error' do
        expect{ image_validation }.to raise_error MemeValidator::Error
      end
    end
  end
end