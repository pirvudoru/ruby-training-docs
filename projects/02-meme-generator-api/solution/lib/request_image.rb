require 'json'
require './lib/image_creator'

class RequestImage

    attr_reader :status , :message , :image_name

    def initialize(body)
      @body = JSON.parse(body)
      validate_params
    end
  
    def create_image
      image_url = @body['meme']['image_url']
      text = @body['meme']['text']
      image_path = Download.download_image(image_url)

      response = ImageCreator.create_meme(image_path, text)
      @status = response[0]
      @image_name = response[1] 
    rescue Download::Error
      @status = 404
      @image_name = nil
    end

    private
  
    def validate_params
      if @body.empty? || !all_required_keys?
        @status = 400
        @message = 'Request sent without parameters or with wrong parameters'
      end
    end

    def all_required_keys?
      expected_keys = %w[image_url text]
      (@body['meme'].keys & expected_keys).size == expected_keys.size
    end
end