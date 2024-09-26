require "./lib/show/command"
require "./lib/search/command"
require "./lib/help/command"

class Program
  class << self
    def execute(argv)
      case argv[0]
      when "show"
        Show::Command.execute(argv[1..])
      when "search"
        Search::Command.execute(argv[1..])
      when "help"
        Help::Command.execute
      else
        Common::ErrorResult.new("Invalid command.")
      end
    end
  end
end
