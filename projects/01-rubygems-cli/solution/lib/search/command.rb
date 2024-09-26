require "./lib/search/result"
require "./lib/search/command_option_parser"
require "./lib/ruby_gems_api/client_with_cache"

module Search
  class Command
    class << self
      def execute(argv)
        return Common::ErrorResult.new("No keyword provided.") if argv.size < 1

        options = Search::CommandOptionParser.parse(argv[1..])

        client = RubyGemsApi::ClientWithCache
        gems = client.search_gems(argv[0])
        gems = options.reduce(gems) { |result, option| option.apply(result) }

        Search::Result.new(gems)
      # rescue StandardError => e
      #   Common::ErrorResult.new(e.message)
      end
    end
  end
end
