module Search
  class MostDownloadsOption
    def apply(gems)
      gems.sort_by { |gem| -gem.downloads }
    end
  end
end
