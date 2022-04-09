require './app/api'

def app
  Sinatra::Application
end

describe 'GET /healthcheck' do
  it 'returns success' do
    get "/healthcheck"

    expect(last_response.status).to eq 200
  end
end

describe 'POST /memes' do
  it 'redirects to the created meme' do
    request_body = {
      meme: {
        "image_url": "http://www.calendarulmagic.ro/wp-content/uploads/2013/11/mickey.jpg",
        "text": "Start the way by organising your playground"
      }
    }

    post '/memes', request_body.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_HOST' => 'foobar.org' }

    expect(last_response.status).to eq 307
    expect(last_response.location).to eq('http://foobar.org/memes/mickey.jpg')
  end
end