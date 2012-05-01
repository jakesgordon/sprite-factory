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

        r = Runner.new(IRREGULAR_PATH)
        assert_equal(IRREGULAR_PATH,          r.input)
        assert_equal(IRREGULAR_PATH,          r.output)
        assert_equal(IRREGULAR_PATH + ".png", r.output_image_file)
        assert_equal(IRREGULAR_PATH + ".css", r.output_style_file)
        assert_equal(IRREGULAR,               r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)

        r = Runner.new(REGULAR_PATH, :output => IRREGULAR_PATH)
        assert_equal(REGULAR_PATH,            r.input)
        assert_equal(IRREGULAR_PATH,          r.output)
        assert_equal(IRREGULAR_PATH + ".png", r.output_image_file)
        assert_equal(IRREGULAR_PATH + ".css", r.output_style_file)
        assert_equal(REGULAR,                 r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)

        r = Runner.new(REGULAR_PATH, :output_image => "foo.png", :output_style => "bar.css.sass.erb")
        assert_equal(REGULAR_PATH,            r.input)
        assert_equal(REGULAR_PATH,            r.output)
        assert_equal("foo.png",               r.output_image_file)
        assert_equal("bar.css.sass.erb",      r.output_style_file)
        assert_equal(REGULAR,                 r.image_files)
        assert_equal(:horizontal,             r.layout_name)
        assert_equal(:css,                    r.style_name)
        assert_equal(:rmagick,                r.library_name)

        r = Runner.new(REGULAR_PATH, :layout => :vertical, :library => :chunkypng, :style => :sass)
        assert_equal(REGULAR_PATH,            r.input)
        assert_equal(REGULAR_PATH,            r.output)
        assert_equal(REGULAR_PATH + ".png",   r.output_image_file)
        assert_equal(REGULAR_PATH + ".sass",  r.output_style_file)
        assert_equal(REGULAR,                 r.image_files)
        assert_equal(:vertical,               r.layout_name)
        assert_equal(:sass,                   r.style_name)
        assert_equal(:chunkypng,              r.library_name)

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

    def test_default_css_path
      Runner.publicize_methods do
        r1 = Runner.new(REGULAR_PATH)
        r2 = Runner.new(REGULAR_PATH, :csspath => "http://s3.amazonaws.com/sf")
        r3 = Runner.new(REGULAR_PATH, :csspath => "<%= image_path('$IMAGE') %>")
        r4 = Runner.new(REGULAR_PATH, :csspath => lambda{|image| "/very/dynamic/path/#{image}"})

        assert_equal("regular.png",                            r1.css_path, "by default, csspath should be basename of the generated sprite image")
        assert_equal("http://s3.amazonaws.com/sf/regular.png", r2.css_path, "allow customization by prepending to basename of the generated sprite image")
        assert_equal("<%= image_path('regular.png') %>",       r3.css_path, "allow customization by providing custom format string with $IMAGE token to be replaced with basename of the generated sprite image")
        assert_equal("/very/dynamic/path/regular.png",         r4.css_path, "allow customization by lambda function - allow caller to decide how to generate css path to sprite image")
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

  end
end
