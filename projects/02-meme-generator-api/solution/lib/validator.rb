class Validator

  class Error < StandardError
    def initialize(message)
      @message = message
    end
  end

  class << self
    def validate_image(body)
      expected_keys = %w[image_url text]
      if body.empty? || ((body['meme'].keys & expected_keys).size != expected_keys.size)
        raise Validator::Error.new('Request sent without parameters or with wrong parameters')
      end
      true
    end

    def validate_auth(body)
      #todo
    end
  end
end