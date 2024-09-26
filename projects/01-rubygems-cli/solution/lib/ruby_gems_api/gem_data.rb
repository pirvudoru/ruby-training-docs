module RubyGemsApi
  class GemData
    attr_reader :name, :info, :downloads, :licenses

    def initialize(gem_data)
      @name = gem_data["name"]
      @info = gem_data["info"]
      @downloads = gem_data["downloads"]
      @licenses = gem_data["licenses"]

      @gem_data = gem_data
    end

    def license?(license)
      licenses.include?(license)
    end

    def to_json(*_args)
      @gem_data.to_json
    end
  end
end
