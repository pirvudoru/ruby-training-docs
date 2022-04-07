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
      if missing_params? || @body.size == 0
        puts 'a intrat aici'
        @status = 400
        @message = 'Request sent without parameters or with wrong parameters'
      end
    end

    def missing_params?
      missing_keys.size > 0
    end
  
    def missing_keys
      expected_keys = ['image_url', 'text']
      @body['meme'].select { |k, _| !expected_keys.include?(k) }
    end

end