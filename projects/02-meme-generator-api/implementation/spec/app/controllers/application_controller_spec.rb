# frozen_string_literal: true

require './app/controllers/application_controller'

def app
  ApplicationController
end

describe 'GET /' do
  it 'returns Hello message' do
    get '/'
    expect(last_response.status).to eq(200)
  end
end

describe 'GET /memes' do
  it 'opens a form' do
    get '/memes'

    expect(last_response.status).to eq(200)
  end
end

describe 'POST /meme' do
  it 'redirects to created image' do
    post '/meme', image_url:'https://images.unsplash.com/photo-1647549831144-09d4c521c1f1',
                  text:'Start the way by organising your playground'

    expect(last_response.status).to eq(303)
    expect(last_response.location).to eq('http://example.org/meme/image1.jpg')
  end

  context 'giving no text' do
    it 'redirect to created image' do
      post '/meme', image_url:'https://images.unsplash.com/photo-1647549831144-09d4c521c1f1',
                    text:''

      expect(last_response.status).to eq(303)
      expect(last_response.location).to eq('http://example.org/meme/image1.jpg')
    end
  end

  context 'giving no image URL' do
    it 'returns error status 400' do
      post '/meme', image_url:'',
                    text:'Start the way by organising your playground'

      expect(last_response.status).to eq(400)
    end
  end
end

describe 'GET /meme/:file_name' do
  it 'opens the created image' do
    file_name = 'image1.jpg'
    get "/meme/#{file_name}"

    expect(last_response.status).to eq(200)
    expect(last_response.content_type).to eq('image/jpeg')
    # check if image is the same as created file
  end
end
