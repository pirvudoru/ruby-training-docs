require "down"

class Download
  class Error < StandardError
    
  end

  class << self 
    def download_image(url)
      begin
        file = Down.download(url) 
        destination_path = "./temp/#{file.original_filename}"
        FileUtils.mv(file.path, destination_path)
        destination_path
      rescue Down::Error => e
        raise Download::Error
      end
    end
  end
end