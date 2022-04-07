require "down"

class Download
  class << self 
    def download_image(url)
      begin
        file = Down.download(url) 
        if File.extname(url) != ""
          FileUtils.mv(file.path, "./temp/#{file.original_filename}")
          file.original_filename 
        else
          FileUtils.mv(file.path, "./temp/#{file.original_filename}.jpg")
          file.original_filename + '.jpg'
        end
      rescue
        'Download failed'
      end
    end
  end
end