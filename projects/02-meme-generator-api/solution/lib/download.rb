require "down"

class Download
  class Error < StandardError
    def initialize(message)
      @message = message
    end
  end

  class << self 
    def download_image(url)
      begin
        file = Down.download(url) 
        destination_path = "./temp/#{file.original_filename}"
        FileUtils.mv(file.path, destination_path)
        destination_path
      rescue Down::Error => e
        raise Download::Error.new('Failed download')
      end
    end
  end
end