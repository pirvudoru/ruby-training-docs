require "faraday"
require "faraday/net_http"
require "json"
require "digest"
require "./lib/ruby_gems_api/gem_not_found_error"
require "./lib/ruby_gems_api/standard_api_error"
require "./lib/ruby_gems_api/gem_data"
require "./lib/settings"

module RubyGemsApi
  class Client
    class << self
      def gem_info(gem_name)
        raise ArgumentError.new("Invalid gem name provided.") if gem_name.nil? || gem_name.empty?

        response = connection.get("/api/v1/gems/#{gem_name}.json")
        raise GemNotFoundError.new("Gem #{gem_name} not found.") if response.status == 404

        raise StandardAPIError.new("An API error occurred.") if response.status != 200

        JSON.parse(response.body)
            .then { |json| GemData.new(json) }
      end

      def search_gems(keyword)
        raise ArgumentError.new("Invalid keyword provided.") if keyword.nil? || keyword.empty?

        response = connection.get("/api/v1/search.json", {query: keyword})
        raise StandardAPIError.new("An API error occurred.") if response.status != 200

        JSON.parse(response.body)
            .map { |json| GemData.new(json)}
      end

      private

      def connection
        @connection ||= Faraday.new("https://rubygems.org") do |faraday|
          faraday.adapter :net_http
          faraday.request :authorization, "Bearer", Settings.rubygems_api_key
        end
      end
    end
  end
end
