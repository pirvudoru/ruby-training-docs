require 'uri'
require 'sinatra'

module ContentType
  JSON = 'application/json'
end

before do
  @body_json = JSON.parse request.body.read if request.content_type == ContentType::JSON
  request.body.rewind
end

get '/healthcheck' do
  status 200
end

post '/memes' do
  uri = URI.parse(@body_json['meme']['image_url'])
  file_name = File.basename(uri.path)

  redirect "/memes/#{file_name}", 307
end
