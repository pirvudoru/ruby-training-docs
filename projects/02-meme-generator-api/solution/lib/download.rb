require "down"

class Download
  class << self 
    def download_image(url)
      begin
        file = Down.download(url)
        FileUtils.mv(file.path, "./temp/#{file.original_filename}")
        file.original_filename
      rescue
        nil
      end
    end
  end
end