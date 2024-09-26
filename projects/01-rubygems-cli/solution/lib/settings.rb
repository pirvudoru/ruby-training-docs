class Settings
  class MissingConfigurationError < StandardError; end

  class << self
    def rubygems_api_key
      ENV['RUBYGEMS_API_KEY'] || (raise MissingConfigurationError, 'RUBYGEMS_API_KEY')
    end
  end
end
