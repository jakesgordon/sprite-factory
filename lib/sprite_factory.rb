module SpriteFactory
  
  #----------------------------------------------------------------------------

  VERSION     = "1.2.0"
  SUMMARY     = "Automatic CSS sprite generator"
  DESCRIPTION = "Combines individual images from a directory into a single sprite image file and creates an appropriate CSS stylesheet"
  LIB         = File.dirname(__FILE__)

  autoload :Runner,  File.join(LIB, 'sprite_factory/runner')  # controller that glues everything together
  autoload :Layout,  File.join(LIB, 'sprite_factory/layout')  # layout calculations
  autoload :Style,   File.join(LIB, 'sprite_factory/style')   # style generators

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
    attr_accessor :csspath
    attr_accessor :pngcrush
  end
  
  #----------------------------------------------------------------------------

  module Library # abstract module for using various image libraries

    autoload :RMagick,   File.join(LIB, 'sprite_factory/library/rmagick')    # concrete module for using RMagick   (loaded on demand)
    autoload :ChunkyPng, File.join(LIB, 'sprite_factory/library/chunky_png') # concrete module for using ChunkyPng (ditto)

    def self.rmagick
      RMagick
    end

    def self.chunkypng
      ChunkyPng
    end

  end

  #----------------------------------------------------------------------------

end

