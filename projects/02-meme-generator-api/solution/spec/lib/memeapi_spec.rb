require './lib/memeapi.rb'


RSpec.describe MemeApi do
  
  def app
    MemeApi 
  end

  describe "POST /memes" do
    it "returns status 303 and redirect link" do
      body = {
        "meme": {
          "image_url": "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg",
          "text": "You got Rick-rolled"
        }
      }

      post '/memes', body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq 303
      expect(last_response.location).to eq 'http://example.org/memes/test.original.jpg'
    end

    it "returns status 404 for failed download" do
      body = {
        "meme": {
          "image_url": "dsadkaskdjaskjdasdaskdjasjkd",
          "text": "You got Rick-rolled"
        }
      }

      post '/memes', body.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq 404
    end

    it "returns status 400 for missing keys in body" do
      body = {
        "meme":{
          "image_url": "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg"
        }
      }

      post '/memes', body.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq 400
    end

    it "returns status 400 for empty body" do
      post '/memes', '{}', { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq 400
    end
  end



  describe "GET" do          
      it "returns an image type" do
        get "/memes/test.original.jpg"
        expect(last_response.content_type).to eq 'image/jpeg'
      end
  end
end