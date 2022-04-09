require './lib/download'
require 'mini_magick'
class ImageCreator
  class << self
    include MiniMagick

    def create_meme(image_path, text)
      image = MiniMagick::Image.new(image_path)
      image.combine_options do |c|
        c.gravity "center"
        c.draw "text 0,200 '#{text}'"
        c.fill "White"
        c.font "Helvetica"
        c.pointsize "60"
      end

      image_name = File.basename(image_path)
      path_to_meme = "./images/#{image_name}"
      image.write(path_to_meme) 
      [303, image_name]
    end
  end
end