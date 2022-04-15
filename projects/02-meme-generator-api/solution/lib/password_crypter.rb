require "bcrypt"

class PasswordCrypter
  class WrongPasswordError < StandardError
  end

  class << self
    def encrypt(password)
      BCrypt::Password.create(password).to_s
    end
    def equal?(hashed, password)
      return true if BCrypt::Password.new(hashed) == password
      
      raise PasswordCrypter::WrongPasswordError.new('Wrong password, please try again.')
    end
  end
end