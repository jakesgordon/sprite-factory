module SpriteFactory

  #----------------------------------------------------------------------------

  VERSION     = "1.7"
  SUMMARY     = "Automatic CSS sprite generator"
  DESCRIPTION = "Combines individual images from a directory into a single sprite image file and creates an appropriate CSS stylesheet"
  LIB         = File.dirname(__FILE__)

  autoload :Runner,  File.join(LIB, 'sprite_factory/runner')  # controller that glues everything together
  autoload :Style,   File.join(LIB, 'sprite_factory/style')   # style generators all live in a single module (for now)

  def self.run!(input, config = {}, &block)
    Runner.new(input, config).run!(&block)
  end

  #
  # fallback defaults for some options can be set at module level to
  # avoid having to pass them to #run! every single time
  #
  class << self
    attr_accessor :report
    attr_accessor :style
    attr_accessor :layout
    attr_accessor :library
    attr_accessor :selector
    attr_accessor :cssurl
    attr_accessor :pngcrush
    attr_accessor :nocomments
    attr_accessor :separator
    attr_accessor :glob
    attr_accessor :sanitizer
  end

  #----------------------------------------------------------------------------

  module Layout # abstract module for various layout strategies

    autoload :Horizontal, File.join(LIB, 'sprite_factory/layout/horizontal') # concrete module for layout in a single horizontal strip
    autoload :Vertical,   File.join(LIB, 'sprite_factory/layout/vertical')   # concrete module for layout in a single vertical strip
    autoload :Packed,     File.join(LIB, 'sprite_factory/layout/packed')     # concrete module for layout in a bin-packed square

    def self.horizontal
      Horizontal
    end

    def self.vertical
      Vertical
    end

    def self.packed
      Packed
    end

  end

  #----------------------------------------------------------------------------

  module Library # abstract module for using various image libraries

    autoload :RMagick,     File.join(LIB, 'sprite_factory/library/rmagick')      # concrete module for using RMagick     (loaded on demand)
    autoload :ChunkyPng,   File.join(LIB, 'sprite_factory/library/chunky_png')   # concrete module for using ChunkyPng   (ditto)
    autoload :ImageMagick, File.join(LIB, 'sprite_factory/library/image_magick') # concrete module for using ImageMagick (ditto)

    def self.rmagick
      RMagick
    end

    def self.chunkypng
      ChunkyPng
    end

    def self.image_magick
      ImageMagick
    end

  end

  #----------------------------------------------------------------------------

  def self.find_files(*args)
    Dir.glob(args, File::FNM_CASEFOLD).sort # we always do case IN-sensitive file lookups and sort the result
  end

  #----------------------------------------------------------------------------

end

