require 'time'
require 'fileutils'

module Common
  class Cache
    DEFAULT_CACHE_EXPIRATION = 48 * 60 * 60
    SEPARATOR = "\n"

    class << self
      def create
        @instance ||= new
      end
    end

    def read(key)
      path = file_path(key)
      return unless File.exist?(path)

      result = File.read(path)
      expires_at, value = result.split(SEPARATOR)
      expires_at = Time.parse(expires_at)
      value if expires_at > Time.now
    end

    def write(key, value, expires_at = Time.now + DEFAULT_CACHE_EXPIRATION)
      File.write(file_path(key), "#{expires_at.iso8601}#{SEPARATOR}#{value}")
    end

    def clear
      FileUtils.rm_r Dir.glob('cache/*.cache')
    end

    private

    def file_path(key)
      "cache/#{key}.cache"
    end
  end
end
