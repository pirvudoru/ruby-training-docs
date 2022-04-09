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
      response = ImageCreator.create_meme(image_url, text)
      @status = response[0]
      @image_name = response[1]
      @image_name
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