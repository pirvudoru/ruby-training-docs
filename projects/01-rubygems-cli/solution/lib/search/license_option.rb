
module Search
  class LicenseOption
    def initialize(license)
      @license = license
    end

    def apply(gems)
      gems.select { |gem| gem.license?(@license) }
    end
  end
end
