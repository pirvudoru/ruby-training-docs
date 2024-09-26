require "./lib/show/result"
require "./lib/common/error_result"
require "./lib/ruby_gems_api/client_with_cache"

module Show
  class Command
    class << self
      def execute(argv)
        return Common::ErrorResult.new("Too many arguments!") if argv.size > 2

        result = RubyGemsApi::ClientWithCache.gem_info(argv[0])
        Show::Result.new(result.name, result.info)
      rescue StandardError => e
        Common::ErrorResult.new(e.message)
      end
    end
  end
end
