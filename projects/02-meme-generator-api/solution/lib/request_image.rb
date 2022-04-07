require 'json'

class RequestImage

    attr_reader :status , :message , :image_link

    def initialize(body)
      @body = body
      validate_params
    end
  
    def create_image
      #todo
    end

    private
  
    def validate_params
      if missing_params? || body.size == 0
        @status = 404
        @message = 'Request sent without parameters or with wrong parameters'
      else
        @status = 307
      end
    end

    def missing_params?
      missing_keys.size > 0
    end
  
    def missing_keys
      expected_keys = [:meme]
      @body.select { |k, _| !expected_keys.has_key?(k) }
    end

end