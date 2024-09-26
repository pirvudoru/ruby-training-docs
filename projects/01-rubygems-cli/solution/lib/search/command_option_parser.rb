require "./lib/search/most_downloads_option"
require "./lib/search/license_option"
require "optparse"

module Search
  class CommandOptionParser
    class << self
      def parse(args)
        options = []

        OptionParser.new do |opts|
          opts.on("--most-downloads-first",
                  "Order gems starting with the downloaded first.") do
            options << MostDownloadsOption.new
          end

          opts.on("--license LICENSE",
                  "Filter gems by specified license.") do |license|
            options << LicenseOption.new(license)
          end
        end.parse!(args)

        options
      end
    end
  end
end
