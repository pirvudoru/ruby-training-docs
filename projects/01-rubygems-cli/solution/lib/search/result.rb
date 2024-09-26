require "./lib/common/result"

module Search
  class Result < Common::Result
    attr_accessor :gems

    def initialize(gems, exit_code = 0)
      super(exit_code)
      @gems = gems
    end

    def output
      result = "\n"
      gems.each_with_index do |gem, i|
        result += "#{i + 1}, #{gem.name}. Downloads: #{format_number(gem.downloads)}\n"
      end

      result
    end

    private

    def format_number(number)
      number.to_s
            .chars
            .reverse
            .each_slice(3)
            .map(&:join)
            .join(',')
            .reverse
    end
  end
end
