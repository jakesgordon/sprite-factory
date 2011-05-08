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
        { :x =>  0, :y =>  0 },       #            |111|333|
        { :x =>  0, :y => 10 },       #            ---------
        { :x => 20, :y =>  0 },       #            |222|444|
        { :x => 20, :y => 10 },       #            ---------
        { :x =>  0, :y => 20 }        #            |555|   |
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
      images = get_irregular_images
                                     # expected: -----------------
      expected = [                   #           |11111111111|444|
        { :x =>    0, :y =>  0 },    #           ------------|444|
        { :x =>    0, :y => 10 },    #           |2222222|   |444|
        { :x =>    0, :y => 30 },    #           ------------|444|
        { :x =>  100, :y =>  0 },    #           |3333|      -----
        { :x =>    0, :y => 60 }     #           -----------------
      ]                              #           |555|           |
                                     #           -----------------
      verify_layout(120, 100, expected, images, :layout => :packed)
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
        { :width => 100, :height => 100 },
        { :width => 100, :height =>  50 },
        { :width =>  50, :height => 100 }
      ]
      images.each do |image|
        verify_layout(image[:width], image[:height], [{:x => 0, :y => 0}], [image], :layout => :packed)
      end
    end

    #==========================================================================
    # some test cases from original bin packing demonstration
    #   (see http://codeincomplete.com/posts/2011/5/7/bin_packing/example/)
    #==========================================================================

    def test_packed_simple
      images = expanded_images([
        { :width => 500, :height => 200             },
        { :width => 250, :height => 200             },
        { :width =>  50, :height =>  50, :num => 20 }
      ])
      expected = [
        { :x => 0,   :y => 0   },
        { :x => 0,   :y => 200 },
        { :x => 250, :y => 200 },
        { :x => 300, :y => 200 },
        { :x => 350, :y => 200 },
        { :x => 400, :y => 200 },
        { :x => 450, :y => 200 },
        { :x => 250, :y => 250 },
        { :x => 300, :y => 250 },
        { :x => 350, :y => 250 },
        { :x => 400, :y => 250 },
        { :x => 450, :y => 250 },
        { :x => 250, :y => 300 },
        { :x => 300, :y => 300 },
        { :x => 350, :y => 300 },
        { :x => 400, :y => 300 },
        { :x => 450, :y => 300 },
        { :x => 250, :y => 350 },
        { :x => 300, :y => 350 },
        { :x => 350, :y => 350 },
        { :x => 400, :y => 350 },
        { :x => 450, :y => 350 }
      ]
      verify_layout(500, 400, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    def test_packed_square
      images = expanded_images([{ :width => 50, :height => 50, :num => 16 }])
      expected = [
        { :x =>   0, :y =>   0 },
        { :x =>  50, :y =>   0 },
        { :x =>   0, :y =>  50 },
        { :x =>  50, :y =>  50 },
        { :x => 100, :y =>   0 },
        { :x => 100, :y =>  50 },
        { :x =>   0, :y => 100 },
        { :x =>  50, :y => 100 },
        { :x => 100, :y => 100 },
        { :x => 150, :y =>   0 },
        { :x => 150, :y =>  50 },
        { :x => 150, :y => 100 },
        { :x =>   0, :y => 150 },
        { :x =>  50, :y => 150 },
        { :x => 100, :y => 150 },
        { :x => 150, :y => 150 }
      ]
      verify_layout(200, 200, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    def test_packed_tall
      images = expanded_images([{ :width => 50, :height => 500, :num => 5 }])
      expected = [
        { :x =>   0, :y => 0 },
        { :x =>  50, :y => 0 },
        { :x => 100, :y => 0 },
        { :x => 150, :y => 0 },
        { :x => 200, :y => 0 }
      ]
      verify_layout(250, 500, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    def test_packed_wide
      images = expanded_images([{ :width => 500, :height => 50, :num => 5 }])
      expected = [
        { :x => 0, :y =>   0 },
        { :x => 0, :y =>  50 },
        { :x => 0, :y => 100 },
        { :x => 0, :y => 150 },
        { :x => 0, :y => 200 }
      ]
      verify_layout(500, 250, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    def test_packed_tall_and_wide
      images = expanded_images([
        { :width =>  50, :height => 500, :num => 3 },
        { :width => 500, :height =>  50, :num => 3 }
      ])
      expected = [
        { :x =>   0, :y =>   0 },
        { :x =>  50, :y =>   0 },
        { :x => 100, :y =>   0 },
        { :x => 150, :y =>   0 },
        { :x => 150, :y =>  50 },
        { :x => 150, :y => 100 }
      ]
      verify_layout(650, 500, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    def test_packed_powers_of_2
      images = expanded_images([
        { :width => 64, :height => 64, :num => 2 },
        { :width => 32, :height => 32, :num => 4 },
        { :width => 16, :height => 16, :num => 8 }
      ])
      expected = [
        { :x =>   0, :y =>   0 },
        { :x =>  64, :y =>   0 },
        { :x =>   0, :y =>  64 },
        { :x =>  32, :y =>  64 },
        { :x =>  64, :y =>  64 },
        { :x =>  96, :y =>  64 },
        { :x =>   0, :y =>  96 },
        { :x =>  16, :y =>  96 },
        { :x =>  32, :y =>  96 },
        { :x =>  48, :y =>  96 },
        { :x =>  64, :y =>  96 },
        { :x =>  80, :y =>  96 },
        { :x =>  96, :y =>  96 },
        { :x => 112, :y =>  96 }
      ]
      verify_layout(128, 112, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    protected

    def expanded_images(images)
      result = images.map do |i|
        (1..(i[:num] || 1)).map{{:width => i[:width], :height => i[:height]}}
      end.flatten
    end

    end # class PackedTest
  end # module Layout
end # module SpriteFactory

