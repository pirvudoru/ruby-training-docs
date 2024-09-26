# frozen_string_literal: true

require "./lib/common/result"

HELP_MESSAGE = "Usage: cli.rb [COMMAND]... [OPTIONS]...\n" \
  "Commands:\n" \
  "    show [GEM NAME]    Display details about specified gem\n" \
  "    search [KEYWORD]   Display a list of all gems that match the specified keyword\n" \
  "\n" \
  "Options:\n" \
  "    <search> --license LICENSE\n" \
  "           Filter gems by specified license.\n" \
  "    <search> --most-downloads-first\n" \
  "           Order gems starting with the downloaded first.\n"           

module Help
  class Result < Common::Result
    def initialize(exit_code = 0)
      super(exit_code)
    end

    def output
      HELP_MESSAGE
    end
  end
end
