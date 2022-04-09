require 'sinatra/base'
require './lib/download'
require './lib/request_image'
require 'pry'

class MemeApi < Sinatra::Application

  class << self
    def run
      run!
    end
  end

  post '/memes' do
    req = RequestImage.new(request.body.read)
    halt req.status, req.message if req.status == 400
    image_name = req.create_image

    return req.status if req.status != 303
    
    redirect "/memes/#{req.image_name}", req.status
    rescue StandardError => e
      pp e
  end


  get '/memes/:file' do
    path = Pathname(__dir__).join("../images/#{params[:file]}")
    send_file(path)
  end

end
