require 'sinatra/base'
require './lib/download'
require 'pry'
require './lib/validators/meme_validator'
require './lib/image_creator'
require './lib/database/database'
require './lib/password_crypter'
require './lib/validators/account_validator'
require './lib/token_generator'
require './lib/password_crypter'

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

  post '/signup' do
    json_body = JSON.parse(request.body.read)
    username, password = AccountValidator.validate_account(json_body)
    database.insert_user(username,PasswordCrypter.encrypt(password))
    token = TokenGenerator.generate
    database.insert_token(username, token)
    
    [201, {"user": {"token": token} }.to_json]
  rescue AccountValidator::ValidationError
    [400, {"errors": ["message": e.message]}.to_json]
  rescue Database::UserExistsError => e
    [409, {"errors": ["message": e.message]}.to_json]
  end
  

  post '/login' do
    json_body = JSON.parse(request.body.read)
    username, password = AccountValidator.validate_account(json_body)
    hashed = database.get_user(username)['password']
    PasswordCrypter.equal?(hashed,password)
    token = database.get_tokens(username)['token']

    [200, {"user": {"token": token } }.to_json]
  rescue AccountValidator::ValidationError
    [400, {"errors": ["message": e.message]}.to_json]
  rescue PasswordCrypter::WrongPasswordError => e
    [400, {"errors": ["message": e.message]}.to_json]
  rescue Database::NonExistentUserError => e
    [400, {"errors": ["message": e.message]}.to_json]
    
  end

  private

  def database
    Database.create
  end
  
end
