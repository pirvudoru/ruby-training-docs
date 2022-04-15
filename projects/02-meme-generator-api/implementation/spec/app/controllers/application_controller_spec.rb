# frozen_string_literal: true

require './app/controllers/application_controller'

def app
  ApplicationController
end

describe 'GET /' do
  it 'returns success status' do
    get '/'
    expect(last_response.status).to eq(200)
  end
end

describe 'POST /memes' do
  request_body_full = {
    meme: {
      'image_url': 'https://images.unsplash.com/photo-1647549831144-09d4c521c1f1',
      'text': 'Start the way by organising your playground'
    }
  }

  it 'redirects to created image' do
    post '/memes', request_body_full.to_json, { 'CONTENT_TYPE' => 'application/json' }

    expect(last_response.status).to eq(303)
    expect(last_response.location).to eq('http://example.org/meme/image1.jpg')
  end

  context 'giving no text' do
    request_body_missing_text = {
      meme: {
        'image_url': 'https://images.unsplash.com/photo-1647549831144-09d4c521c1f1'
      }
    }

    it 'redirects to created image' do
      post '/memes', request_body_missing_text.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(303)
      expect(last_response.location).to eq('http://example.org/meme/image1.jpg')
    end
  end

  context 'giving no image URL' do
    request_body_missing_image_url = {
      meme: {
        'text': 'Start the way by organising your playground'
      }
    }

    it 'returns error status 400' do
      post '/memes', request_body_missing_image_url.to_json, { 'CONTENT_TYPE' => 'application/json' }

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

describe 'POST /signup' do
  context 'creating a user record' do
    let(:request_body) {
      {
        user: {
          'username': 'mr_bean',
          'password': 'test123'
        }
      }
    }

    it 'returns a user token' do
      post '/signup', request_body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(201)

      @body_json = JSON.parse(last_response.body)
      expect(@body_json['user']['token'].length).to be >= 1
    end
  end

  context 'giving invalid request body' do
    let(:request_body) {
      {
        cat: {
          'color': 'blue',
          'language': 'miau'
        }
      }
    }

    it 'returns error code 400' do
      post '/signup', request_body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)
    end
  end

  context 'giving a blank username' do
    let(:request_body) {
      {
        user: {
          'username': '',
          'password': 'test123'
        }
      }
    }

    it 'returns 400 error code with Username is blank message' do
      post '/signup', request_body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)

      @body_json = JSON.parse(last_response.body)
      expect(@body_json['errors'][0]['message']).to eq('Username is blank')
    end
  end

  context 'giving a blank password' do
    let(:request_body) {
      {
        user: {
          'username': 'mr_bean',
          'password': ''
        }
      }
    }

    it 'returns 400 error code with Password is blank message' do
      post '/signup', request_body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)

      @body_json = JSON.parse(last_response.body)
      expect(@body_json['errors'][0]['message']).to eq('Password is blank')
    end
  end

  context 'user already exists' do
    let(:request_body) {
      {
        user: {
          'username': 'mr_bean',
          'password': 'test123'
        }
      }
    }

    it 'returns 409 error code' do
      post '/signup', request_body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(409)
    end
  end

  after(:all) do
    AuthenticationClient.delete_user('mr_bean')
  end
end

describe 'POST /login' do
  before(:all) do
    AuthenticationClient.create_user('mr_bean', 'test123')
  end

  context 'logging in a user' do
    let(:request_body) {
      {
        user: {
          'username': 'mr_bean',
          'password': 'test123'
        }
      }
    }

    it 'returns a user token' do
      post '/login', request_body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(200)

      @body_json = JSON.parse(last_response.body)
      expect(@body_json['user']['token'].length).to be >= 1
    end
  end

  context 'giving unknown user' do
    let(:request_body) {
      {
        user: {
          'username': 'cat',
          'password': 'test123'
        }
      }
    }

    it 'returns 400 error code with Incorrect user credentials message' do
      post '/login', request_body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)

      @body_json = JSON.parse(last_response.body)
      expect(@body_json['errors'][0]['message']).to eq('Incorrect user credentials')
    end
  end

  context 'giving wrong password' do
    let(:request_body) {
      {
        user: {
          'username': 'mr_bean',
          'password': 'testcat'
        }
      }
    }

    it 'returns 400 error code with Incorrect user credentials message' do
      post '/login', request_body.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(400)

      @body_json = JSON.parse(last_response.body)
      expect(@body_json['errors'][0]['message']).to eq('Incorrect user credentials')
    end
  end

  after(:all) do
    AuthenticationClient.delete_user('mr_bean')
  end
end