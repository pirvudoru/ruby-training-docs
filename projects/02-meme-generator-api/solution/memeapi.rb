require 'sinatra/base'
require './lib/download'
require './lib/request_image'

class MemeApi < Sinatra::Application

  MemeApi.post '/memes' do
    res = JSON.parse( JSON.generate(request.body.read) )
    pp(res)
    #req = RequestImage.new(request_payload)
    #halt req.status, req.message if req.status != 307

    #url_to_redirect = req.create_image

    200
  end


  MemeApi.get '/memes/:file' do
    path = File.dirname(__FILE__) + '/temp/' + params[:file] 
    send_file(path)
  end

  run!
end