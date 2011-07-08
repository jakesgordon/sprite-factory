require 'RMagick'

module SpriteFactory
  module Library
    module RMagick

      VALID_EXTENSIONS = [:png, :PNG, :jpg, :JPG, :jpeg, :JPEG, :gif, :GIF]

      def self.load(files)
        files.map do |filename|
          image = Magick::Image.read(filename)[0]
          {
            :filename => filename,
            :image    => image,
            :width    => image.columns,
            :height   => image.rows
          }
        end
      end

      def self.create(filename, images, width, height)
        target = Magick::Image.new(width,height)
        target.opacity = Magick::MaxRGB
        images.each do |image|
          target.composite!(image[:image], image[:x], image[:y], Magick::SrcOverCompositeOp)
        end
        target.write(filename)
      end

    end # module RMagick
  end # module Library
end # module SpriteFactory
