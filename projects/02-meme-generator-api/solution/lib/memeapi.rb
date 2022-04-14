require 'sinatra/base'
require './lib/download'
require 'pry'
require './lib/validators/meme_validator'
require './lib/image_creator'

class MemeApi < Sinatra::Application

  class << self
    def run
      run!
    end
  end

  post '/memes' do
    json_body = JSON.parse(request.body.read)
    MemeValidator.validate_image(json_body)
    image_path = Download.download_image(json_body['meme']['image_url'])
    image_name = ImageCreator.create_meme(image_path, json_body['meme']['text'])
    redirect "/memes/#{image_name}", 303
    rescue Download::Error => e
      status 404
    rescue MemeValidator::Error => e
      status 400
  end

  get '/memes/:file' do
    path = Pathname(__dir__).join("../images/#{params[:file]}")
    send_file(path)
  end
  
  
end
