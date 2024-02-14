require 'pathname'
require 'fileutils'

module SpriteFactory
  class Runner

    #----------------------------------------------------------------------------

    PSEUDO_CLASS_ORDER = [nil, ':link', ':visited', ':focus', ':hover', ':active'] # TODO: allow caller to specify this order ?

    #----------------------------------------------------------------------------

    attr :input
    attr :config

    def initialize(input, config = {})
      @input  = input.to_s[-1] == "/" ? input[0...-1] : input # gracefully ignore trailing slash on input directory name
      @config = config
      @config[:style]      ||= SpriteFactory.style    || :css
      @config[:layout]     ||= SpriteFactory.layout   || :horizontal
      @config[:library]    ||= SpriteFactory.library  || :rmagick
      @config[:selector]   ||= SpriteFactory.selector || 'img.'
      @config[:cssurl]     ||= SpriteFactory.cssurl
      @config[:report]     ||= SpriteFactory.report
      @config[:pngcrush]   ||= SpriteFactory.pngcrush
      @config[:nocomments] ||= SpriteFactory.nocomments
      @config[:separator]  ||= SpriteFactory.separator || '_'
      @config[:glob]       ||= SpriteFactory.glob      || '*'
      @config[:sanitizer]  ||= SpriteFactory.sanitizer
      @config[:exclude]    ||= SpriteFactory.exclude   || []
    end

    #----------------------------------------------------------------------------

    def run!(&block)
      raise RuntimeError, "unknown layout #{layout_name}"     if !Layout.respond_to?(layout_name)
      raise RuntimeError, "unknown style #{style_name}"       if !Style.respond_to?(style_name)
      raise RuntimeError, "unknown library #{library_name}"   if !Library.respond_to?(library_name)

      raise RuntimeError, "input must be a single directory"  if input.nil?  || input.to_s.empty? || !File.directory?(input)
      raise RuntimeError, "no image files found"              if image_files.empty?
      raise RuntimeError, "no output file specified"          if output.to_s.empty?
      raise RuntimeError, "no output image file specified"    if output_image_file.to_s.empty?
      raise RuntimeError, "no output style file specified"    if output_style_file.to_s.empty?

      raise RuntimeError, "set :width for fixed width, or :hpadding for horizontal padding, but not both." if width  && !hpadding.zero?
      raise RuntimeError, "set :height for fixed height, or :vpadding for vertical padding, but not both." if height && !vpadding.zero?
      raise RuntimeError, "set :width for fixed width, or :hmargin for horizontal margin, but not both." if width  && !hmargin.zero?
      raise RuntimeError, "set :height for fixed height, or :vmargin for vertical margin, but not both." if height && !hmargin.zero?

      raise RuntimeError, "The legacy :csspath attribute is no longer supported, please use :cssurl instead (see README)" unless @config[:csspath].nil?

      images = load_images
      max    = layout_images(images)
      header = summary(images, max)

      report(header)

      css = []
      css << style_comment(header) unless nocomments?                       # header comment
      css << style(selector, css_url, images, &block)                       # generated styles
      css << IO.read(custom_style_file) if File.exist?(custom_style_file)  # custom styles
      css = css.join("\n")

      create_sprite(images, max[:width], max[:height])

      unless nocss?
        css_file = File.open(output_style_file, "w+")
        css_file.puts css
        css_file.close
      end

      if config[:return] == :images
        images # if caller explicitly asked for detailed images hash instead of generated CSS
      else
        css    # otherwise, default is to return the generated CSS to caller in string form
      end

    end

    #----------------------------------------------------------------------------

    private

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

    def hmargin
      config[:hmargin] || config[:margin] || 0
    end

    def vmargin
      config[:vmargin] || config[:margin] || 0
    end

    def width
      config[:width]
    end

    def height
      config[:height]
    end

    def output
      config[:output] || input
    end

    def output_image_file
      config[:output_image] || "#{output}.png"
    end

    def output_style_file
      config[:output_style] || "#{output}.#{style_name}"
    end

    def nocss?
      config[:nocss] # set true if you dont want an output style file generated (e.g. you will take the #run! output and store it yourself)
    end

    def nocomments?
      config[:nocomments] # set true if you dont want any comments in the output style file
    end

    def separator
      config[:separator]
    end

    def sanitizer
      config[:sanitizer]
    end

    def exclude
      config[:exclude]
    end

    def exclude?(file)
      Array(exclude).any? { |name| file.include?(name) }
    end

    def custom_style_file
      File.join(input, File.basename(input) + ".#{style_name}")
    end

    def css_url
      base = File.basename(output_image_file)
      custom = config[:cssurl]
      if custom
        if custom.is_a?(Proc)
          custom.call(base)                 # allow custom url using a lambda
        elsif custom.include?('$IMAGE')
          custom.sub('$IMAGE', base)        # allow custom url with simple token replacement
        else
          "url(#{File.join(custom, base)})" # allow custom url with simple prepend
        end
      else
        "url(#{base})"                      # otherwise, just default to basename of the output image file
      end
    end

    #----------------------------------------------------------------------------

    def image_files
      return [] if input.nil?
      valid_extensions = library::VALID_EXTENSIONS
      expansions = Array(valid_extensions).map{|ext| File.join(input, "**", "#{config[:glob]}.#{ext}")}
      files = SpriteFactory.find_files(*expansions)
      files = files.reject{ |file| exclude?(file) }
      files
    end

    #----------------------------------------------------------------------------

    def library
      @library ||= Library.send(library_name)
    end

    def load_images
      input_path = Pathname.new(input)

      images = library.load(image_files)
      images.each do |i|
        i[:name], i[:ext] = extract_image_filename(i[:filename], input_path)
        raise RuntimeError, "image #{i[:name]} does not fit within a fixed width of #{width}" if width && (width < i[:width])
        raise RuntimeError, "image #{i[:name]} does not fit within a fixed height of #{height}" if height && (height < i[:height])
      end
      images.sort_by {|i| [image_name_without_pseudo_class(i), image_pseudo_class_priority(i)] }
    end

    def extract_image_filename(filename, input_path)
      name = Pathname.new(filename).relative_path_from(input_path).to_s.gsub(File::SEPARATOR, separator)
      ext  = File.extname(name)
      name = name[0...-ext.length] unless ext.empty?
      name = sanitize_image_filename(name)
      [name, ext]
    end

    def sanitize_image_filename(name)
      if sanitizer.is_a?(Proc)
        sanitizer.call(name)                   # custom sanitizer
      elsif sanitizer
        name.gsub(/[^\w-]/, '')                # (opt-in) clean all non-word characters
      else
        name.gsub('--', ':').gsub('__', ' ')   # legacy behavior
      end
    end

    def image_name_without_pseudo_class(image)
      image[:name].split(':').first
    end

    def image_pseudo_class(image)
      image[:name].slice(/:.*?\Z/)
    end

    def image_pseudo_class_priority(image)
      PSEUDO_CLASS_ORDER.index(image_pseudo_class(image))
    end

    #----------------------------------------------------------------------------

    def create_sprite(images, width, height)
      library.create(output_image_file, images, width, height)
      pngcrush(output_image_file)
    end

    #----------------------------------------------------------------------------

    def layout_strategy
      @layout_strategy ||= Layout.send(layout_name)
    end

    def layout_images(images)
      layout_strategy.layout(images, :width => width, :height => height, :hpadding => hpadding, :vpadding => vpadding, :hmargin => hmargin, :vmargin => vmargin)
    end

    #----------------------------------------------------------------------------

    def style(selector, url, images, &block)
      defaults = Style.generate(style_name, selector, url, images) # must call, even if custom block is given, because it stashes generated css style into image[:style] attributes
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

    SUPPORTS_PNGCRUSH = !`which pngcrush`.empty? rescue false # rescue on environments without `which` (windows)

    def pngcrush(image)
      if SUPPORTS_PNGCRUSH && config[:pngcrush]
        crushed = "#{image}.crushed"
        system('pngcrush', '-q', '-rem alla', '-reduce', '-brute', image, crushed)
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
