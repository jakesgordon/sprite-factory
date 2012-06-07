module SpriteFactory
  module Style

    #----------------------------------------------------------------------------

    def self.css(selector, name, attributes)
      "#{selector}#{name} { #{css_style(attributes)}; }"
    end

    def self.css_style(attributes)
      attributes.join("; ")
    end

    def self.css_comment(comment)
      return "/*\n#{comment}\n*/"
    end

    #----------------------------------------------------------------------------

    def self.scss(selector, name, attributes)
      css(selector, name, attributes) # scss is a superset of css, but we dont actually need any of the extra bits, so just defer to the css generator instead
    end

    def self.scss_style(attributes)
      css_style(attributes)
    end

    def self.scss_comment(comment)
      css_comment(comment)
    end

    #----------------------------------------------------------------------------

    def self.sass(selector, name, attributes)
      "#{selector}#{name}\n" + sass_style(attributes)
    end

    def self.sass_style(attributes)
      attributes.map{|a| "  #{a}"}.join("\n") + "\n"
    end

    def self.sass_comment(comment)
      return "/* #{comment.rstrip} */" # SASS has peculiar indenting requirements in order to recognise closing block comment
    end

    #----------------------------------------------------------------------------

    def self.generate(style_name, selector, path, images)
      styles = []
      images.each do |image|
        attr = [
          "width: #{image[:cssw]}px",
          "height: #{image[:cssh]}px",
          "background: url(#{path}) #{-image[:cssx]}px #{-image[:cssy]}px no-repeat"
        ]
        image[:path] = path
        image[:selector] = selector
        image[:style] = send("#{style_name}_style", attr) # make pure style available for (optional) custom rule generators (see usage of yield inside Runner#style)
        styles << send(style_name, selector, image[:name], attr)
      end
      styles << ""
      styles.join("\n")
    end

    #----------------------------------------------------------------------------

    def self.comment(style_name, comment)
      send("#{style_name}_comment", comment)
    end

    #----------------------------------------------------------------------------

  end
end
