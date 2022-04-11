require 'sinatra/base'
require './lib/download'
require './lib/request_image'
require 'pry'
require './lib/validator'

class MemeApi < Sinatra::Application

  class << self
    def run
      run!
    end
  end

  post '/memes' do
    #req = RequestImage.new(request.body.read)
    #halt req.status, req.message if req.status == 400
    #image_name = req.create_image
    json_body = JSON.parse(request.body.read)
    validation = Validator.validate_image(json_body)
    unless validation
      halt 400, validation.message
    end
    image_path = Download.download_image(json_body['meme']['image_url'])
    image_name = ImageCreator.create_meme(image_path, json_body['meme']['text'])
    redirect "/memes/#{image_name}", 303
    rescue Download::Error => e
      halt 404, e.message
  end


  get '/memes/:file' do
    path = Pathname(__dir__).join("../images/#{params[:file]}")
    send_file(path)
  end

end
