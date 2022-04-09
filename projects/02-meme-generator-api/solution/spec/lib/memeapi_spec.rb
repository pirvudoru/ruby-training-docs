require './lib/memeapi.rb'

def app
  MemeApi 
end


describe "GET" do      
  context "no todos" do      
    it "returns no todo" do
      get "/"
      expect(last_response.status).to eq 200
    end
  end
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

  it "returns status 400 for wrong request body" do
    body = {
      "meme":{
        "image_url": "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg"
      }
    }

    post '/memes', body.to_json, { 'CONTENT_TYPE' => 'application/json' }

    expect(last_response.status).to eq 400

  end
end
