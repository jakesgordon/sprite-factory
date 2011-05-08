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
                                     :layout   => :packed)
    end

    def test_generate_regular_sprite_with_padding
      integration_test(REGULAR_PATH, :output   => output_path('regular.padded'),
                                     :selector => 'img.padded_',
                                     :padding  => 10)
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
                                       :layout   => :packed)
    end

    def test_generate_irregular_sprite_with_padding
      integration_test(IRREGULAR_PATH, :output   => output_path('irregular.padded'),
                                       :selector => 'img.padded_',
                                       :padding  => 10)
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

  end
end
