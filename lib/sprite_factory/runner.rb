require 'pathname'
require 'fileutils'

module SpriteFactory
  class Runner

    #----------------------------------------------------------------------------

    attr :input
    attr :config
  
    def initialize(input, config = {})
      @input  = input.to_s[-1] == "/" ? input[0...-1] : input # gracefully ignore trailing slash on input directory name
      @config = config
      @config[:style]    ||= SpriteFactory.style    || :css
      @config[:layout]   ||= SpriteFactory.layout   || :horizontal
      @config[:library]  ||= SpriteFactory.library  || :rmagick
      @config[:selector] ||= SpriteFactory.selector || 'img.'
      @config[:csspath]  ||= SpriteFactory.csspath
      @config[:report]   ||= SpriteFactory.report
    end
  
    #----------------------------------------------------------------------------

    def run!(&block)

      raise RuntimeError, "unknown layout #{layout_name}"     if !Layout.respond_to?(layout_name)
      raise RuntimeError, "unknown style #{style_name}"       if !Style.respond_to?(style_name)
      raise RuntimeError, "unknown library #{library_name}"   if !Library.respond_to?(library_name)

      raise RuntimeError, "input must be a single directory"  if input.nil?  || input.to_s.empty? || !File.directory?(input)
      raise RuntimeError, "no output file specified"          if output.nil? || output.to_s.empty?
      raise RuntimeError, "no image files found"              if image_files.empty?

      raise RuntimeError, "set :width for fixed width, or :hpadding for horizontal padding, but not both." if width  && !hpadding.zero?
      raise RuntimeError, "set :height for fixed height, or :vpadding for vertical padding, but not both." if height && !vpadding.zero?

      images = load_images
      max    = layout_images(images)
      header = summary(images, max)

      create_sprite(images, max[:width], max[:height])

      css_file = File.open(output_style_file, "w+")
      css_file.puts style_comment(header)
      css_file.puts style(selector, css_path, images, &block)
      css_file.puts IO.read(custom_style_file) if File.exists?(custom_style_file)
      css_file.close

      report(header)

    end

    #----------------------------------------------------------------------------
  
    private

    def output
      config[:output] || input
    end

    def selector
      config[:selector]
    end

    def style_name
      config[:style]
    end

    def layout_name
      config[:layout]
    end

    def library_name
      config[:library]
    end

    def hpadding
      config[:hpadding] || config[:padding] || 0
    end

    def vpadding
      config[:vpadding] || config[:padding] || 0
    end

    def width
      config[:width]
    end

    def height
      config[:height]
    end

    def output_image_file
      "#{output}.png" if output
    end

    def output_style_file
      "#{output}.#{style_name}" if output and style_name
    end

    def custom_style_file
      File.join(input, File.basename(input) + ".#{style_name}")
    end

    def css_path
      base   = File.basename(output_image_file)
      custom = config[:csspath]
      if custom
        if custom.is_a?(Proc)
          custom.call(base)          # allow custom path using a lambda
        elsif custom.include?('$IMAGE')
          custom.sub('$IMAGE', base) # allow custom path with token replacement
        else
          File.join(custom, base)    # allow custom path with simple prepend
        end
      else
        base                         # otherwise, just default to basename of the output image
      end
    end

    def image_files
      return [] if input.nil?
      valid_extensions = library::VALID_EXTENSIONS
      expansions = Array(valid_extensions).map{|ext| File.join(input, "**", "*.#{ext}")}
      Dir[*expansions].sort
    end

    #----------------------------------------------------------------------------

    def library
      @library ||= Library.send(library_name)
    end

    def load_images
      images = library.load(image_files)
      images.each do |i|
        i[:name] = File.basename(i[:filename])
        i[:ext]  = File.extname(i[:name])
        i[:name] = i[:name][0...-i[:ext].length] unless i[:ext].empty?

        raise RuntimeError, "image #{i[:name]} does not fit within a fixed width of #{width}" if width && (width < i[:width])
        raise RuntimeError, "image #{i[:name]} does not fit within a fixed height of #{height}" if height && (height < i[:height])
      end
      images
    end

    def create_sprite(images, width, height)
      library.create(output_image_file, images, width, height)
      pngcrush(output_image_file)
    end

    #----------------------------------------------------------------------------

    def layout_images(images)
      Layout.send(layout_name, images, :width => width, :height => height, :hpadding => hpadding, :vpadding => vpadding)
    end

    #----------------------------------------------------------------------------

    def style(selector, path, images, &block)
      defaults = Style.generate(style_name, selector, path, images) # must call, even if custom block is given, because it stashes generated css style into image[:style] attributes
      if block_given?
        yield images.inject({}) {|h,i| h[i[:name].to_sym] = i; h} # provide custom rule builder a hash by image name
      else
        defaults
      end
    end

    def style_comment(comment)
      Style.comment(style_name, comment)
    end

    #----------------------------------------------------------------------------

    SUPPORTS_PNGCRUSH = !`which pngcrush`.empty?

    def pngcrush(image)
      if SUPPORTS_PNGCRUSH && config[:pngcrush]
        crushed = "#{image}.crushed"
        `pngcrush -rem alla -reduce -brute #{image} #{crushed}`
        FileUtils.mv(crushed, image) 
      end
    end

    #----------------------------------------------------------------------------

    def summary(images, max)
      return <<-EOF

        Creating a sprite from following images:
        \n#{images.map{|i| "        #{report_path(i[:filename])} (#{i[:width]}x#{i[:height]})" }.join("\n")}

        Output files:
          #{report_path(output_image_file)}
          #{report_path(output_style_file)}

        Output size:
          #{max[:width]}x#{max[:height]}

      EOF
    end

    def report(msg)
      puts msg if config[:report]
    end

    def report_path(path) # always report paths relative to . to avoid machine specific information in report (to avoid DIFF issues in tests and version control)
      @cwd ||= Pathname.new(File.expand_path('.'))
      path = Pathname.new(path)
      path = path.relative_path_from(@cwd) if path.absolute?
      path.to_s
    end

    #----------------------------------------------------------------------------

  end # class Runner
end # module SpriteFactory
