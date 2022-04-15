class MemeValidator
  class Error < StandardError
    
  end

  class << self
    def validate_image(body)
      expected_keys = %w[image_url text]
      if body.empty? || ((body['meme'].keys & expected_keys).size != expected_keys.size)
        raise MemeValidator::Error
      end
      true
    end
  end
end