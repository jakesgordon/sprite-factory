require File.expand_path('test_case', File.dirname(__FILE__))

module SpriteFactory
  class RunnerTest < SpriteFactory::TestCase

    #----------------------------------------------------------------------------

    def test_defaults

      Runner.publicize_methods do

        r = Runner.new(REGULAR_PATH) 
        assert_equal(REGULAR_PATH,            r.input)
        assert_equal(REGULAR_PATH,            r.output)
        assert_equal(REGULAR_PATH + ".png",   r.output_image_file)
        assert_equal(REGULAR_PATH + ".css",   r.output_style_file)
        assert_equal(REGULAR,                 r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)
        assert_equal(DIRECTORY_SEPARATOR,     r.directory_separator)
        assert_equal([],                      r.exclusion_array)


        r = Runner.new(IRREGULAR_PATH)
        assert_equal(IRREGULAR_PATH,          r.input)
        assert_equal(IRREGULAR_PATH,          r.output)
        assert_equal(IRREGULAR_PATH + ".png", r.output_image_file)
        assert_equal(IRREGULAR_PATH + ".css", r.output_style_file)
        assert_equal(IRREGULAR,               r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)
        assert_equal(DIRECTORY_SEPARATOR,     r.directory_separator)
        assert_equal([],                      r.exclusion_array)


        r = Runner.new(IRREGULAR_PATH, :directory_separator => '.')
        assert_equal(IRREGULAR_PATH,          r.input)
        assert_equal(IRREGULAR_PATH,          r.output)
        assert_equal(IRREGULAR_PATH + ".png", r.output_image_file)
        assert_equal(IRREGULAR_PATH + ".css", r.output_style_file)
        assert_equal(IRREGULAR,               r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)
        assert_equal('.',     r.directory_separator)

        r = Runner.new(REGULAR_PATH, :output => IRREGULAR_PATH)
        assert_equal(REGULAR_PATH,            r.input)
        assert_equal(IRREGULAR_PATH,          r.output)
        assert_equal(IRREGULAR_PATH + ".png", r.output_image_file)
        assert_equal(IRREGULAR_PATH + ".css", r.output_style_file)
        assert_equal(REGULAR,                 r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)
        assert_equal(DIRECTORY_SEPARATOR,     r.directory_separator)
        assert_equal([],                      r.exclusion_array)


        r = Runner.new(REGULAR_PATH, :exclude => ['foo.png']) 
        assert_equal(REGULAR_PATH,            r.input)
        assert_equal(REGULAR_PATH,            r.output)
        assert_equal(REGULAR_PATH + ".png",   r.output_image_file)
        assert_equal(REGULAR_PATH + ".css",   r.output_style_file)
        assert_equal(REGULAR,                 r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)
        assert_equal(DIRECTORY_SEPARATOR,     r.directory_separator)
        assert_equal(['foo.png'],             r.exclusion_array)

        r = Runner.new(REGULAR_PATH, :output_image => "foo.png", :output_style => "bar.css.sass.erb")
        assert_equal(REGULAR_PATH,            r.input)
        assert_equal(REGULAR_PATH,            r.output)
        assert_equal("foo.png",               r.output_image_file)
        assert_equal("bar.css.sass.erb",      r.output_style_file)
        assert_equal(REGULAR,                 r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)
        assert_equal(DIRECTORY_SEPARATOR,     r.directory_separator)
        assert_equal([],                      r.exclusion_array)


        r = Runner.new(REGULAR_PATH, :layout => :vertical, :library => :chunkypng, :style => :sass)
        assert_equal(REGULAR_PATH,            r.input)
        assert_equal(REGULAR_PATH,            r.output)
        assert_equal(REGULAR_PATH + ".png",   r.output_image_file)
        assert_equal(REGULAR_PATH + ".sass",  r.output_style_file)
        assert_equal(REGULAR,                 r.image_files)
        assert_equal(:vertical,               r.layout_name)
        assert_equal(:sass,                   r.style_name)
        assert_equal(:chunkypng,              r.library_name)
        assert_equal(DIRECTORY_SEPARATOR,     r.directory_separator)
        assert_equal([],                      r.exclusion_array)


      end
    
    end

    #----------------------------------------------------------------------------

    def test_default_padding
      Runner.publicize_methods do
        r = Runner.new(REGULAR_PATH)
        assert_equal(0, r.hpadding)
        assert_equal(0, r.vpadding)

        r = Runner.new(REGULAR_PATH, :padding => 10)
        assert_equal(10, r.hpadding)
        assert_equal(10, r.vpadding)

        r = Runner.new(REGULAR_PATH, :hpadding => 10, :vpadding => 20)
        assert_equal(10, r.hpadding)
        assert_equal(20, r.vpadding)
      end
    end

    def test_default_margin
      Runner.publicize_methods do
        r = Runner.new(REGULAR_PATH)
        assert_equal(0, r.hmargin)
        assert_equal(0, r.vmargin)

        r = Runner.new(REGULAR_PATH, :margin => 10)
        assert_equal(10, r.hmargin)
        assert_equal(10, r.vmargin)

        r = Runner.new(REGULAR_PATH, :hmargin => 10, :vmargin => 20)
        assert_equal(10, r.hmargin)
        assert_equal(20, r.vmargin)
      end
    end

    #----------------------------------------------------------------------------

    def test_default_css_url
      Runner.publicize_methods do
        r1 = Runner.new(REGULAR_PATH)
        r2 = Runner.new(REGULAR_PATH, :cssurl => "http://s3.amazonaws.com/sf")
        r3 = Runner.new(REGULAR_PATH, :cssurl => "foo(<%= image_path('$IMAGE') %>)")
        r4 = Runner.new(REGULAR_PATH, :cssurl => lambda{|image| "foo(/very/dynamic/path/#{image})" })

        assert_equal("url(regular.png)",                            r1.css_url, "by default, css_url should be basename of the generated sprite image")
        assert_equal("url(http://s3.amazonaws.com/sf/regular.png)", r2.css_url, "allow customization by prepending to basename of the generated sprite image")
        assert_equal("foo(<%= image_path('regular.png') %>)",       r3.css_url, "allow customization by providing custom format string with $IMAGE token to be replaced with basename of the generated sprite image")
        assert_equal("foo(/very/dynamic/path/regular.png)",         r4.css_url, "allow customization by lambda function - allow caller to decide how to generate css url to sprite image")
      end
    end

    #----------------------------------------------------------------------------

    def test_trailing_slash_on_input_is_ignored
      Runner.publicize_methods do
        r = Runner.new("#{REGULAR_PATH}/")
        assert_equal(REGULAR_PATH,          r.input)
        assert_equal(REGULAR_PATH,          r.output)
        assert_equal(REGULAR_PATH + ".png", r.output_image_file)
        assert_equal(REGULAR_PATH + ".css", r.output_style_file)
        assert_equal(REGULAR,               r.image_files)
      end
    end

    #----------------------------------------------------------------------------

    def test_invalid_config

      assert_runtime_error "input must be a single directory" do
        SpriteFactory.run!("")
      end

      assert_runtime_error "input must be a single directory" do
        SpriteFactory.run!(REGULAR.first)
      end

      assert_runtime_error "no output file specified" do
        SpriteFactory.run!(REGULAR_PATH, :output => "")
      end

      assert_runtime_error "no image files found" do
        SpriteFactory.run!(EMPTY_PATH)
      end

      assert_runtime_error "unknown layout diagonal" do
        SpriteFactory.run!(REGULAR_PATH, :layout => :diagonal)
      end

      assert_runtime_error "unknown style funky" do
        SpriteFactory.run!(REGULAR_PATH, :style => :funky)
      end

      assert_runtime_error "unknown library hogwarts" do
        SpriteFactory.run!(REGULAR_PATH, :library => :hogwarts)
      end

      assert_runtime_error "exclude must be an array type" do
        SpriteFactory.run!(REGULAR_PATH, :exclude => "")
      end

      assert_runtime_error "set :width for fixed width, or :hpadding for horizontal padding, but not both." do
        SpriteFactory.run!(REGULAR_PATH, :width => 50, :padding => 10)
      end

      assert_runtime_error "set :height for fixed height, or :vpadding for vertical padding, but not both." do
        SpriteFactory.run!(REGULAR_PATH, :height => 50, :padding => 10)
      end

      assert_runtime_error "set :width for fixed width, or :hmargin for horizontal margin, but not both." do
        SpriteFactory.run!(REGULAR_PATH, :width => 50, :margin => 10)
      end

      assert_runtime_error "set :height for fixed height, or :vmargin for vertical margin, but not both." do
        SpriteFactory.run!(REGULAR_PATH, :height => 50, :margin => 10)
      end

      assert_runtime_error "image regular1 does not fit within a fixed width of 10" do
        SpriteFactory.run!(REGULAR_PATH, :width => 10)
      end

      assert_runtime_error "image regular1 does not fit within a fixed height of 10" do
        SpriteFactory.run!(REGULAR_PATH, :height => 10)
      end

    end

    #----------------------------------------------------------------------------

    def test_images_are_filtered_correctly
      Runner.publicize_methods do
        expected = REGULAR_INFO.map{ |i| i[:filename] }
        excluded = expected.pop(2)
        actual = Runner.new(REGULAR_PATH, :exclude => excluded).image_files
        assert_equal(expected, actual)
      end
    end

    def test_images_are_sorted_in_classname_order
      Runner.publicize_methods do
        expected = [
          "alice",
          "codeincomplete",
          "github",
          "monkey",
          "spies",
          "stackoverflow",
          "thief"
        ]
        actual = Runner.new(FORMATS_PATH).load_images.map{|i| i[:name]}
        assert_equal(expected, actual)
      end
    end

    def test_images_are_secondary_sorted_on_psuedoclass
      Runner.publicize_methods do
        expected = [
          "div.bar img.icon",
          "div.bar img.icon:link",
          "div.bar img.icon:visited",
          "div.bar img.icon:focus",
          "div.bar img.icon:hover",
          "div.bar img.icon:active",
          "div.foo img.icon",
          "div.foo img.icon:link",
          "div.foo img.icon:visited",
          "div.foo img.icon:focus",
          "div.foo img.icon:hover",
          "div.foo img.icon:active",
        ]
        actual = Runner.new(HOVER_PATH).load_images.map{|i| i[:name]}
        assert_equal(expected, actual)
      end
    end

    def test_use_specified_directory_separator
      Runner.publicize_methods do
        expected = %w(england.amy england.bob france.bob usa.amy usa.bob)
        actual = Runner.new(SUBFOLDERS_PATH, :directory_separator => '.').load_images.map{|i| i[:name]}
        assert_equal(expected, actual)
      end
    end

    #----------------------------------------------------------------------------

  end
end
