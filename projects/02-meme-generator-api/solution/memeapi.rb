require 'sinatra/base'
require './lib/download'
require './lib/request_image'

class MemeApi < Sinatra::Application

  MemeApi.post '/memes' do
    req = RequestImage.new(request.body.read)
    halt req.status, req.message if req.status == 400
    image_name = req.create_image

    return req.status if req.status != 307
    
    redirect "/memes/#{req.image_name}", req.status
  end


  MemeApi.post '/memes/:file' do
    path = File.dirname(__FILE__) + '/images/' + params[:file] 
    send_file(path)
  end

  run!
end