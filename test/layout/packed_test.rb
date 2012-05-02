require File.expand_path('test_case', File.dirname(__FILE__))

module SpriteFactory
  module Layout
    class PackedTest < SpriteFactory::Layout::TestCase

    #==========================================================================
    # test REGULAR images
    #==========================================================================

    def test_packed_layout_of_regular_images
      images = get_regular_images
      expected = [                                                                  # expected:  -------
        { :cssx =>  0, :cssy =>  0, :cssw => 20, :cssh => 10, :x =>  0, :y =>  0 }, #            |11|33|
        { :cssx =>  0, :cssy => 10, :cssw => 20, :cssh => 10, :x =>  0, :y => 10 }, #            -------
        { :cssx => 20, :cssy =>  0, :cssw => 20, :cssh => 10, :x => 20, :y =>  0 }, #            |22|44|
        { :cssx => 20, :cssy => 10, :cssw => 20, :cssh => 10, :x => 20, :y => 10 }, #            -------
        { :cssx =>  0, :cssy => 20, :cssw => 20, :cssh => 10, :x =>  0, :y => 20 }  #            |55|  |
      ]                                                                             #            -------
      verify_layout(40, 30, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    def test_padded_packed_layout_of_regular_images                                  # expected:  ---------------
                                                                                     #            |      |      |
      images = get_regular_images                                                    #            |  11  |  33  |
      expected = [                                                                   #            |      |      |
        { :cssx =>  0, :cssy =>  0, :cssw => 60, :cssh => 30, :x => 20, :y => 10 },  #            ---------------
        { :cssx =>  0, :cssy => 30, :cssw => 60, :cssh => 30, :x => 20, :y => 40 },  #            |      |      |
        { :cssx => 60, :cssy =>  0, :cssw => 60, :cssh => 30, :x => 80, :y => 10 },  #            |  22  |  44  |
        { :cssx => 60, :cssy => 30, :cssw => 60, :cssh => 30, :x => 80, :y => 40 },  #            |      |      |
        { :cssx =>  0, :cssy => 60, :cssw => 60, :cssh => 30, :x => 20, :y => 70 }   #            ---------------
      ]                                                                              #            |      |
      verify_layout(120, 90, expected, images, :layout => :packed,                   #            |  55  |
                                               :hpadding => 20,                      #            |      |
                                               :vpadding => 10)                      #            --------
    end
                                          
    #--------------------------------------------------------------------------

    def test_margin_packed_layout_of_regular_images                                  # expected:  ---------------
                                                                                     #            |      |      |
      images = get_regular_images                                                    #            |  11  |  33  |
      expected = [                                                                   #            |      |      |
        { :cssx => 20, :cssy => 10, :cssw => 20, :cssh => 10, :x => 20, :y => 10 },  #            ---------------
        { :cssx => 20, :cssy => 40, :cssw => 20, :cssh => 10, :x => 20, :y => 40 },  #            |      |      |
        { :cssx => 80, :cssy => 10, :cssw => 20, :cssh => 10, :x => 80, :y => 10 },  #            |  22  |  44  |
        { :cssx => 80, :cssy => 40, :cssw => 20, :cssh => 10, :x => 80, :y => 40 },  #            |      |      |
        { :cssx => 20, :cssy => 70, :cssw => 20, :cssh => 10, :x => 20, :y => 70 }   #            ---------------
      ]                                                                              #            |      |
      verify_layout(120, 90, expected, images, :layout => :packed,                   #            |  55  |
                                               :hmargin => 20,                       #            |      |
                                               :vmargin => 10)                       #            --------
    end

    #--------------------------------------------------------------------------

    def test_fixed_packed_layout_of_regular_images
      assert_not_implemented ":packed layout does not support fixed :width/:height option" do
        Layout::Packed.layout(get_regular_images, :width => 50, :height => 50)
      end
    end 

    #==========================================================================
    # test IRREGULAR images
    #==========================================================================

    def test_packed_layout_of_irregular_images
      images = get_irregular_images
                                                                                        # expected: ---------------
      expected = [                                                                      #           |1111111111|44|
        { :cssx =>   0, :cssy =>  0, :cssw => 100, :cssh => 10, :x =>    0, :y =>  0 }, #           -----------|44|
        { :cssx =>   0, :cssy => 10, :cssw =>  80, :cssh => 20, :x =>    0, :y => 10 }, #           |22222222| |44|
        { :cssx =>   0, :cssy => 30, :cssw =>  60, :cssh => 30, :x =>    0, :y => 30 }, #           -----------|44|
        { :cssx => 100, :cssy =>  0, :cssw =>  20, :cssh => 50, :x =>  100, :y =>  0 }, #           |333333|   ----
        { :cssx =>   0, :cssy => 60, :cssw =>  40, :cssh => 40, :x =>    0, :y => 60 }  #           ---------------
      ]                                                                                 #           |5555|        |
                                                                                        #           ---------------
      verify_layout(120, 100, expected, images, :layout => :packed)
    end

    #--------------------------------------------------------------------------

    def test_padded_packed_layout_of_irregular_images                                     # expected: (but with more vertical padding than shown here)
      images = get_irregular_images                                                       #
                                                                                          #  ------------------------- 
      expected = [                                                                        #  |  1111111111  |  4444  | 
        { :cssx =>   0, :cssy =>   0, :cssw => 140, :cssh => 30, :x =>   20, :y =>  10 }, #  ----------------  4444  | 
        { :cssx =>   0, :cssy =>  30, :cssw => 120, :cssh => 40, :x =>   20, :y =>  40 }, #  |  22222222  | ---------- 
        { :cssx =>   0, :cssy =>  70, :cssw => 100, :cssh => 50, :x =>   20, :y =>  80 }, #  --------------          | 
        { :cssx => 140, :cssy =>   0, :cssw =>  80, :cssh => 60, :x =>  160, :y =>  10 }, #  |  333333  |            | 
        { :cssx =>   0, :cssy => 120, :cssw =>  60, :cssh => 70, :x =>   20, :y => 130 }  #  |-----------            | 
      ]                                                                                   #  |  55  |                | 
                                                                                          #  ------------------------- 
      verify_layout(220, 190, expected, images, :layout   => :packed,                     #
                                                :hpadding => 20,                          #
                                                :vpadding => 10)                          #
    end

    #--------------------------------------------------------------------------

    def test_margin_packed_layout_of_irregular_images                                     # expected: (but with more vertical margin than shown here)
      images = get_irregular_images                                                       #
                                                                                          #  ------------------------- 
      expected = [                                                                        #  |  1111111111  |  4444  | 
        { :cssx =>  20, :cssy =>  10, :cssw => 100, :cssh => 10, :x =>   20, :y =>  10 }, #  ----------------  4444  | 
        { :cssx =>  20, :cssy =>  40, :cssw =>  80, :cssh => 20, :x =>   20, :y =>  40 }, #  |  22222222  | ---------- 
        { :cssx =>  20, :cssy =>  80, :cssw =>  60, :cssh => 30, :x =>   20, :y =>  80 }, #  --------------          | 
        { :cssx => 160, :cssy =>  10, :cssw =>  40, :cssh => 40, :x =>  160, :y =>  10 }, #  |  333333  |            | 
        { :cssx =>  20, :cssy => 130, :cssw =>  20, :cssh => 50, :x =>   20, :y => 130 }  #  |-----------            | 
      ]                                                                                   #  |  55  |                | 
                                                                                          #  ------------------------- 
      verify_layout(220, 190, expected, images, :layout  => :packed,                      #
                                                :hmargin => 20,                           #
                                                :vmargin => 10)                           #
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

