require File.expand_path('test_case', File.dirname(__FILE__))

module SpriteFactory
  module Layout
    class PackedTest < SpriteFactory::Layout::TestCase

    #==========================================================================
    # test REGULAR images
    #==========================================================================

    def test_packed_layout_of_regular_images
      images = get_regular_images
      expected = [                    # expected:  ---------
        { :x =>  0, :y =>  0 },       #            | 1 | 3 |
        { :x =>  0, :y => 10 },       #            ---------
        { :x => 20, :y =>  0 },       #            | 2 | 4 |
        { :x => 20, :y => 10 },       #            ---------
        { :x =>  0, :y => 20 }        #            | 5 |   |
      ]                               #            ---------
      verify_layout(40, 30, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    def test_padded_packed_layout_of_regular_images
      # TODO
    end

    #--------------------------------------------------------------------------

    def test_fixed_packed_layout_of_regular_images
      # TODO
    end 

    #==========================================================================
    # test IRREGULAR images
    #==========================================================================

    def test_packed_layout_of_irregular_images
      # TODO
    end

    #--------------------------------------------------------------------------

    def test_padded_packed_layout_of_irregular_images
      # TODO
    end

    #--------------------------------------------------------------------------

    def test_fixed_packed_layout_of_irregular_images
      # TODO
    end

    #==========================================================================
    # other packed algorithm test
    #==========================================================================

    def test_single_image_is_100_percent_packed
      images = [
        { :width => 100, :height => 100 }
      ]
      expected = [
        { :x => 0, :y => 0 }
      ]
      verify_layout(100, 100, expected, images, :layout => :packed)
    end

    #==========================================================================
    # test cases from original bin packing demonstration
    #   (see http://codeincomplete.com/posts/2011/5/7/bin_packing/example/)
    #==========================================================================

    def test_packed_simple
    end

    def test_packed_square
    end

    def test_packed_tall
    end

    def test_packed_wide
    end

    def test_packed_tall_and_wide
    end

    def test_packed_powers_of_2
    end

    def test_packed_odd_and_even
    end

    def test_complex
    end

    #--------------------------------------------------------------------------

    end # class PackedTest
  end # module Layout
end # module SpriteFactory

