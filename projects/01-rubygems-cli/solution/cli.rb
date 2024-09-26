#!/usr/bin/env ruby

require "./lib/program"

result = Program.execute(ARGV)
puts(result.output)
exit(result.exit_code)
