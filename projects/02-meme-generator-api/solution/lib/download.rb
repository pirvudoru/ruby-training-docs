require "down"

class Download
  class << self 
    def download_image(url)
      begin
        file = Down.download(url) 
        destination_path = "./temp/#{file.original_filename}"
        FileUtils.mv(file.path, destination_path)
        destination_path
      rescue StandardError => e
        'Download failed'
      end
    end
  end
end