class AccountValidator
  class RequestBodyError < StandardError 
  end

  class EmptyParameterError < StandardError
  end

  class << self
    def validate_account(body)
      expected_keys = %w[username password]
      if body.empty? || body['user'].keys.empty? ||((body['user'].keys & expected_keys).size != expected_keys.size) 
        raise AccountValidator::RequestBodyError
      end
      raise AccountValidator::EmptyParameterError.new('Username is blank') if body['user']['username'].empty?
      raise AccountValidator::EmptyParameterError.new('Password is blank') if body['user']['password'].empty?
      [body['user']['username'],body['user']['password']]
    end
  end
end