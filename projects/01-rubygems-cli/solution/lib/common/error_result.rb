require "./lib/common/result"

module Common
  class ErrorResult < Common::Result
    attr_accessor :error_message

    def initialize(error_message, exit_code = 1)
      super(exit_code)
      @error_message = error_message
    end

    def output
      error_message
    end
  end
end
