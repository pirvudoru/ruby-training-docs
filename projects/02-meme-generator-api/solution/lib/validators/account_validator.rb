class AccountValidator
  class ValidationError < StandardError
  end

  class << self
    def validate_account(body)
      expected_keys = %w[username password]
      if body.empty? || body['user'].keys.empty? ||((body['user'].keys & expected_keys).size != expected_keys.size) 
        raise AccountValidator::ValidationError, "Bad request body"
      end
      raise AccountValidator::ValidationError.new('Username is blank') if body['user']['username'].empty?
      raise AccountValidator::ValidationError.new('Password is blank') if body['user']['password'].empty?
      [body['user']['username'], body['user']['password']]
    end
  end
end
