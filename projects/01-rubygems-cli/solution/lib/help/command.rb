require "./lib/help/result"

module Help
  class Command
    class << self
      def execute
        Help::Result.new
      end
    end
  end
end
