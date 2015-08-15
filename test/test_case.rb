require File.expand_path('../lib/sprite_factory', File.dirname(__FILE__))
require 'minitest/autorun'

module SpriteFactory
  class TestCase < Minitest::Test

    #----------------------------------------------------------------------------

    IMAGES_PATH    = 'test/images'

    REFERENCE_PATH  = 'test/images/reference'
    REGULAR_PATH    = 'test/images/regular'
    IRREGULAR_PATH  = 'test/images/irregular'
    CUSTOM_PATH     = 'test/images/custom'
    FORMATS_PATH    = 'test/images/formats'
    EMPTY_PATH      = 'test/images/empty'
    SUBFOLDERS_PATH = 'test/images/subfolders'
    HOVER_PATH      = 'test/images/hover'
    GLOB_PATH       = 'test/images/glob'

    REGULAR   = SpriteFactory.find_files(File.join(REGULAR_PATH,   '*.png'))
    IRREGULAR = SpriteFactory.find_files(File.join(IRREGULAR_PATH, '*.png'))

    REGULAR_INFO = [
      { :filename => REGULAR[0], :width => 64, :height => 64 },
      { :filename => REGULAR[1], :width => 64, :height => 64 },
      { :filename => REGULAR[2], :width => 64, :height => 64 },
      { :filename => REGULAR[3], :width => 64, :height => 64 },
      { :filename => REGULAR[4], :width => 64, :height => 64 }
    ]

    IRREGULAR_INFO = [
      { :filename => IRREGULAR[0], :width => 60, :height => 60 },
      { :filename => IRREGULAR[1], :width => 16, :height => 16 },
      { :filename => IRREGULAR[2], :width => 48, :height => 48 },
      { :filename => IRREGULAR[3], :width => 34, :height => 14 },
      { :filename => IRREGULAR[4], :width => 46, :height => 25 }
    ]

    DIRECTORY_SEPARATOR = '_'

    def output_path(name)
      File.join(IMAGES_PATH, name)
    end

    def reference_path(name)
      File.join(REFERENCE_PATH, name)
    end

    #----------------------------------------------------------------------------

    def integration_test(input, options = {}, &block)
      output = options[:output] || input
      with_clean_output do 
        SpriteFactory.run!(input, options, &block)
        assert_reference_image(File.basename(output) + "." + (                   :png).to_s)
        assert_reference_style(File.basename(output) + "." + (options[:style] || :css).to_s)
      end
    end

    #----------------------------------------------------------------------------

    def with_clean_output
      begin
        clean_output
        yield
      ensure
        clean_output
      end
    end

    def clean_output
      SpriteFactory.find_files(File.join(IMAGES_PATH, "*.png"),
                               File.join(IMAGES_PATH, "*.css"),
                               File.join(IMAGES_PATH, "*.sass"),
                               File.join(IMAGES_PATH, "*.scss")).each do |f|
        File.delete(f)
      end
    end

    #----------------------------------------------------------------------------

    def assert_runtime_error(msg = nil)
      e = assert_raises RuntimeError do
        yield
      end
      assert_match(msg, e.message) if msg
    end

    def assert_not_implemented(msg = nil)
      e = assert_raises NotImplementedError do
        yield
      end
      assert_match(msg, e.message) if msg
    end

    #----------------------------------------------------------------------------

    def assert_reference_image(name)
      #
      # images generated with different libraries (or different versions of same library)
      # might have different headers, so use rmagick to actually compare image bytes
      #
      actual         = output_path(name)
      expected       = reference_path(name)
      actual_image   = Magick::Image.read(actual)[0]
      expected_image = Magick::Image.read(expected)[0]
      img, val       = expected_image.compare_channel(actual_image, Magick::MeanAbsoluteErrorMetric)
      assert_equal(0.0, val, "generated image does not match pregenerated reference:\n actual:   #{actual}\n expected: #{expected}")
    end

    def assert_reference_style(name)
      actual   = output_path(name)
      expected = reference_path(name)
      diff = `cmp #{expected} #{actual}`
      assert(diff.empty?, "generated styles do not match pregenerated reference:\n#{diff}")
    end

    #----------------------------------------------------------------------------

  end # class TestCase
end # module SpriteFactory


#==============================================================================

class Class

  # allow tests to call private methods without ugly #send syntax
  def publicize_methods
    methods = private_instance_methods
    send(:public, *methods)
    yield
    send(:private, *methods) 
  end

end

#==============================================================================


