require 'securerandom'

class TokenGenerator
  class << self
    def generate
      SecureRandom.hex(20)
    end
  end
end