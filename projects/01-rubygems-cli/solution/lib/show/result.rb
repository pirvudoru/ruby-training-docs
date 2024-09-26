require "./lib/common/result"

module Show
  class Result < Common::Result
    attr_accessor :gem_name, :info

    def initialize(gem_name, info, exit_code = 0)
      super(exit_code)
      @gem_name = gem_name
      @info = info
    end

    def output
      "#{gem_name}\n#{info}"
    end
  end
end
