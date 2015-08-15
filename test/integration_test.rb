require File.expand_path('test_case', File.dirname(__FILE__))

module SpriteFactory
  class IntegrationTest < SpriteFactory::TestCase

    #----------------------------------------------------------------------------

    def test_generate_regular_sprite
      integration_test(REGULAR_PATH)
    end

    def test_generate_horizontal_regular_sprite
      integration_test(REGULAR_PATH, :output   => output_path('regular.horizontal'),
                                     :selector => 'img.horizontal_',
                                     :layout   => :horizontal)
    end

    def test_generate_vertical_regular_sprite
      integration_test(REGULAR_PATH, :output   => output_path('regular.vertical'),
                                     :selector => 'img.vertical_',
                                     :layout   => :vertical)
    end

    def test_generate_packed_regular_sprite
      integration_test(REGULAR_PATH, :output   => output_path('regular.packed'),
                                     :selector => 'img.packed_',
                                     :layout   => :packed,
                                     :padding  => 10,
                                     :margin   => 10)
    end

    def test_generate_regular_sprite_with_padding
      integration_test(REGULAR_PATH, :output   => output_path('regular.padded'),
                                     :selector => 'img.padded_',
                                     :padding  => 10)
    end

    def test_generate_regular_sprite_with_margin
      integration_test(REGULAR_PATH, :output   => output_path('regular.margin'),
                                     :selector => 'img.margin_',
                                     :margin   => 10)
    end

    def test_generate_regular_sprite_with_fixed_size
      integration_test(REGULAR_PATH, :output   => output_path('regular.fixed'),
                                     :selector => 'img.fixed_',
                                     :width    => 100,
                                     :height   => 100)
    end

    def test_generate_regular_sprite_with_sassy_style
      integration_test(REGULAR_PATH, :output   => output_path('regular.sassy'),
                                     :selector => 'img.sassy_',
                                     :style    => :sass)
    end

    def test_generate_regular_with_nocomments
      integration_test(REGULAR_PATH, :output     => output_path('regular.nocomments'),
                                     :selector   => 'img.nocomments_',
                                     :nocomments => true)
    end

    #----------------------------------------------------------------------------

    def test_generate_irregular_sprite
      integration_test(IRREGULAR_PATH)
    end

    def test_generate_horizontal_irregular_sprite
      integration_test(IRREGULAR_PATH, :output   => output_path('irregular.horizontal'),
                                       :selector => 'img.horizontal_',
                                       :layout   => :horizontal)
    end

    def test_generate_vertical_irregular_sprite
      integration_test(IRREGULAR_PATH, :output   => output_path('irregular.vertical'),
                                       :selector => 'img.vertical_',
                                       :layout   => :vertical)
    end

    def test_generate_packed_irregular_sprite
      integration_test(IRREGULAR_PATH, :output   => output_path('irregular.packed'),
                                       :selector => 'img.packed_',
                                       :layout   => :packed,
                                       :padding  => 10,
                                       :margin   => 10)
    end

    def test_generate_irregular_sprite_with_padding
      integration_test(IRREGULAR_PATH, :output   => output_path('irregular.padded'),
                                       :selector => 'img.padded_',
                                       :padding  => 10)
    end

    def test_generate_irregular_sprite_with_margin
      integration_test(IRREGULAR_PATH, :output   => output_path('irregular.margin'),
                                       :selector => 'img.margin_',
                                       :margin  => 10)
    end

    def test_generate_irregular_sprite_with_fixed_size
      integration_test(IRREGULAR_PATH, :output   => output_path('irregular.fixed'),
                                       :selector => 'img.fixed_',
                                       :width    => 100,
                                       :height   => 100)
    end

    def test_generate_irregular_sprite_with_sassy_style
      integration_test(IRREGULAR_PATH, :output   => output_path('irregular.sassy'),
                                       :selector => 'img.sassy_',
                                       :style    => :sass)
    end

    #----------------------------------------------------------------------------

    def test_generate_custom_sprite
      integration_test(CUSTOM_PATH) do |images|
        rules = []
        rules << "div.running img.button { cursor: pointer; #{images[:running][:style]} }"
        rules << "div.stopped img.button { cursor: pointer; #{images[:stopped][:style]} }"
        rules.join("\n")
      end
    end

    #----------------------------------------------------------------------------

    def test_generate_sprite_from_other_formats
      integration_test(FORMATS_PATH, :library => :rmagick)
    end

    #----------------------------------------------------------------------------

    def test_generate_sprite_using_images_in_subfolders
      integration_test(SUBFOLDERS_PATH)
    end

    #----------------------------------------------------------------------------

    def test_generate_sprites_with_hover_pseudo_class
      integration_test(HOVER_PATH, :selector => 'div.hover ')
    end

    #----------------------------------------------------------------------------

    def test_generate_with_custom_glob
      integration_test(GLOB_PATH, :glob => 'included*')
    end

    #----------------------------------------------------------------------------

    def test_generate_with_sanitizer
      integration_test(NAMES_PATH, :output   => output_path('sanitized'),
                                   :sanitizer => true)
    end

    #----------------------------------------------------------------------------

    def test_generate_with_custom_sanitizer
      integration_test(NAMES_PATH, :output    => output_path('sanitized.custom'),
                                   :sanitizer => lambda {|name| name.gsub(/\\?[^\w]/, '_').downcase })
    end

    #----------------------------------------------------------------------------

    def test_generate_sprite_with_nocss
      input  = REGULAR_PATH
      output = File.basename(REGULAR_PATH)
      with_clean_output do

        assert_equal(false, File.exists?(output_path(output + ".png")), "preconditions")
        assert_equal(false, File.exists?(output_path(output + ".css")), "preconditions")

        css = SpriteFactory.run!(REGULAR_PATH, {:nocss => true})

        assert_equal(true,  File.exists?(output_path(output + ".png")), "output sprite IMAGE should exist")
        assert_equal(false, File.exists?(output_path(output + ".css")), "output sprite CSS should NOT exist")
        assert_equal(IO.read(reference_path(output+".css")), css, "expected return value from #run! to provide generated CSS content")

        assert_reference_image(output + ".png")

      end
    end

    #----------------------------------------------------------------------------

  end
end
