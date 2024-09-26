require "json"
require "digest"
require "./lib/ruby_gems_api/client"
require "./lib/ruby_gems_api/gem_data"
require "./lib/common/cache"

module RubyGemsApi
  class ClientWithCache
    class << self
      def gem_info(gem_name)
        key = cache_key("gem_info,#{gem_name}")
        cached_data = cache.read(key)

        if cached_data
          p 'Using Cache'
          GemData.new(JSON.parse(cached_data))
        else
          result = Client.gem_info(gem_name)
          cache.write(key, result.to_json)
          result
        end
      end

      def search_gems(keyword)
        key = cache_key("search,#{keyword}")
        cached_data = cache.read(key)

        if cached_data
          p 'Using Cache'
          JSON.parse(cached_data).map { |data| GemData.new(data) }
        else
          result = Client.search_gems(keyword)
          cache.write(key, result.to_json)
          result
        end
      end

      private

      def cache
        Common::Cache.create
      end

      def cache_key(*args)
        Digest::MD5.hexdigest(args.join(''))
      end
    end
  end
end
