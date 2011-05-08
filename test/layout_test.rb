require File.expand_path('test_case', File.dirname(__FILE__))

module SpriteFactory
  class LayoutTest < SpriteFactory::TestCase

    #==========================================================================
    # test REGULAR images
    #==========================================================================

    def test_horizontal_layout_of_regular_images
      images = get_regular_images
      expected = [
        { :x =>  0, :y => 0 },
        { :x => 20, :y => 0 },
        { :x => 40, :y => 0 },
        { :x => 60, :y => 0 },
        { :x => 80, :y => 0 }
      ]
      verify_layout(100, 10, expected, images, :layout => :horizontal)
    end


    #--------------------------------------------------------------------------

    def test_vertical_layout_of_regular_images
      images = get_regular_images
      expected = [
        { :x => 0, :y =>  0 },
        { :x => 0, :y => 10 },
        { :x => 0, :y => 20 },
        { :x => 0, :y => 30 },
        { :x => 0, :y => 40 }
      ]
      verify_layout(20, 50, expected, images, :layout => :vertical)
    end

    #--------------------------------------------------------------------------

    def test_padded_horizontal_layout_of_regular_images
      images = get_regular_images
      expected = [
        { :cssx =>   0, :cssy => 0, :cssw => 40, :cssh => 50, :x =>  10, :y => 20 },
        { :cssx =>  40, :cssy => 0, :cssw => 40, :cssh => 50, :x =>  50, :y => 20 },
        { :cssx =>  80, :cssy => 0, :cssw => 40, :cssh => 50, :x =>  90, :y => 20 },
        { :cssx => 120, :cssy => 0, :cssw => 40, :cssh => 50, :x => 130, :y => 20 },
        { :cssx => 160, :cssy => 0, :cssw => 40, :cssh => 50, :x => 170, :y => 20 }
      ]
      verify_layout(200, 50, expected, images, :layout => :horizontal, :hpadding => 10, :vpadding => 20)
    end

    #--------------------------------------------------------------------------

    def test_padded_vertical_layout_of_regular_images
      images = get_regular_images
      expected = [
        { :cssx => 0, :cssy =>   0, :cssw => 40, :cssh => 50, :x => 10, :y =>  20 },
        { :cssx => 0, :cssy =>  50, :cssw => 40, :cssh => 50, :x => 10, :y =>  70 },
        { :cssx => 0, :cssy => 100, :cssw => 40, :cssh => 50, :x => 10, :y => 120 },
        { :cssx => 0, :cssy => 150, :cssw => 40, :cssh => 50, :x => 10, :y => 170 },
        { :cssx => 0, :cssy => 200, :cssw => 40, :cssh => 50, :x => 10, :y => 220 }
      ]
      verify_layout(40, 250, expected, images, :layout => :vertical, :hpadding => 10, :vpadding => 20)
    end

    #--------------------------------------------------------------------------

    def test_fixed_horizontal_layout_of_regular_images
      images = get_regular_images
      expected = [
        { :cssx =>   0, :cssy => 0, :cssw => 50, :cssh => 50, :x =>  15, :y => 20 },
        { :cssx =>  50, :cssy => 0, :cssw => 50, :cssh => 50, :x =>  65, :y => 20 },
        { :cssx => 100, :cssy => 0, :cssw => 50, :cssh => 50, :x => 115, :y => 20 },
        { :cssx => 150, :cssy => 0, :cssw => 50, :cssh => 50, :x => 165, :y => 20 },
        { :cssx => 200, :cssy => 0, :cssw => 50, :cssh => 50, :x => 215, :y => 20 }
      ]
      verify_layout(250, 50, expected, images, :layout => :horizontal, :width => 50, :height => 50)
    end

    #--------------------------------------------------------------------------

    def test_fixed_vertical_layout_of_regular_images
      images = get_regular_images
      expected = [
        { :cssx => 0, :cssy =>   0, :cssw => 50, :cssh => 50, :x =>  15, :y =>  20 },
        { :cssx => 0, :cssy =>  50, :cssw => 50, :cssh => 50, :x =>  15, :y =>  70 },
        { :cssx => 0, :cssy => 100, :cssw => 50, :cssh => 50, :x =>  15, :y => 120 },
        { :cssx => 0, :cssy => 150, :cssw => 50, :cssh => 50, :x =>  15, :y => 170 },
        { :cssx => 0, :cssy => 200, :cssw => 50, :cssh => 50, :x =>  15, :y => 220 }
      ]
      verify_layout(50, 250, expected, images, :layout => :vertical, :width => 50, :height => 50)
    end

    #==========================================================================
    # test IRREGULAR images
    #==========================================================================

    def test_horizontal_layout_of_irregular_images
      images = get_irregular_images
      expected = [
        { :x =>   0, :y =>  0 },
        { :x =>  20, :y =>  5 },
        { :x =>  60, :y => 10 },
        { :x => 120, :y => 15 },
        { :x => 200, :y => 20 }
      ]
      verify_layout(300, 50, expected, images, :layout => :horizontal)
    end

    #--------------------------------------------------------------------------

    def test_vertical_layout_of_irregular_images
      images = get_irregular_images
      expected = [
        { :x => 40, :y =>   0 },
        { :x => 30, :y =>  50 },
        { :x => 20, :y =>  90 },
        { :x => 10, :y => 120 },
        { :x =>  0, :y => 140 }
      ]
      verify_layout(100, 150, expected, images, :layout => :vertical)
    end

    #--------------------------------------------------------------------------

    def test_padded_horizontal_layout_of_irregular_images
      images = get_irregular_images
      expected = [
        { :cssx =>   0, :cssy =>  0, :cssw =>  40, :cssh => 90, :x =>  10, :y => 20 },
        { :cssx =>  40, :cssy =>  5, :cssw =>  60, :cssh => 80, :x =>  50, :y => 25 },
        { :cssx => 100, :cssy => 10, :cssw =>  80, :cssh => 70, :x => 110, :y => 30 },
        { :cssx => 180, :cssy => 15, :cssw => 100, :cssh => 60, :x => 190, :y => 35 },
        { :cssx => 280, :cssy => 20, :cssw => 120, :cssh => 50, :x => 290, :y => 40 }
      ]
      verify_layout(400, 90, expected, images, :layout => :horizontal, :hpadding => 10, :vpadding => 20)
    end

    #--------------------------------------------------------------------------

    def test_padded_vertical_layout_of_irregular_images
      images = get_irregular_images
      expected = [
        { :cssx => 40, :cssy =>   0, :cssw =>  40, :cssh => 90, :x => 50, :y =>  20 },
        { :cssx => 30, :cssy =>  90, :cssw =>  60, :cssh => 80, :x => 40, :y => 110 },
        { :cssx => 20, :cssy => 170, :cssw =>  80, :cssh => 70, :x => 30, :y => 190 },
        { :cssx => 10, :cssy => 240, :cssw => 100, :cssh => 60, :x => 20, :y => 260 },
        { :cssx =>  0, :cssy => 300, :cssw => 120, :cssh => 50, :x => 10, :y => 320 }
      ]
      verify_layout(120, 350, expected, images, :layout => :vertical, :hpadding => 10, :vpadding => 20)
    end

    #--------------------------------------------------------------------------

    def test_fixed_horizontal_layout_of_irregular_images
      images = get_irregular_images
      expected = [
        { :cssx =>   0, :cssy => 0, :cssw => 100, :cssh => 100, :x =>  40, :y => 25 },
        { :cssx => 100, :cssy => 0, :cssw => 100, :cssh => 100, :x => 130, :y => 30 },
        { :cssx => 200, :cssy => 0, :cssw => 100, :cssh => 100, :x => 220, :y => 35 },
        { :cssx => 300, :cssy => 0, :cssw => 100, :cssh => 100, :x => 310, :y => 40 },
        { :cssx => 400, :cssy => 0, :cssw => 100, :cssh => 100, :x => 400, :y => 45 }
      ]
      verify_layout(500, 100, expected, images, :layout => :horizontal, :width => 100, :height => 100)
    end

    #--------------------------------------------------------------------------

    def test_fixed_vertical_layout_of_irregular_images
      images = get_irregular_images
      expected = [
        { :cssx => 0, :cssy =>   0, :cssw => 100, :cssh => 100, :x => 40, :y =>  25 },
        { :cssx => 0, :cssy => 100, :cssw => 100, :cssh => 100, :x => 30, :y => 130 },
        { :cssx => 0, :cssy => 200, :cssw => 100, :cssh => 100, :x => 20, :y => 235 },
        { :cssx => 0, :cssy => 300, :cssw => 100, :cssh => 100, :x => 10, :y => 340 },
        { :cssx => 0, :cssy => 400, :cssw => 100, :cssh => 100, :x =>  0, :y => 445 }
      ]
      verify_layout(100, 500, expected, images, :layout => :vertical, :width => 100, :height => 100)
    end

    #==========================================================================
    # private test helpers
    #==========================================================================

    private

    def get_regular_images
      return [
        {:width => 20, :height => 10},
        {:width => 20, :height => 10},
        {:width => 20, :height => 10},
        {:width => 20, :height => 10},
        {:width => 20, :height => 10}
      ]
    end

    def get_irregular_images
      return [
        {:width => 20,  :height => 50},
        {:width => 40,  :height => 40},
        {:width => 60,  :height => 30},
        {:width => 80,  :height => 20},
        {:width => 100, :height => 10}
      ]
    end

    #--------------------------------------------------------------------------

    def verify_layout(expected_width, expected_height, expected_images, images, options = {})
      max = Layout.send(options[:layout] || :horizontal).layout(images, options)
      assert_equal(expected_width, max[:width])
      assert_equal(expected_height, max[:height])
      assert_equal(expected_images.length, images.length)
      images.length.times.each do |n|
        expected = expected_images[n]
        actual   = images[n]
        assert_equal(expected[:x],                       actual[:x],    "image #{n} - unexpected x")
        assert_equal(expected[:y],                       actual[:y],    "image #{n} - unexpected y")
        assert_equal(expected[:cssx] || expected[:x],    actual[:cssx], "image #{n} - unexpected cssx")
        assert_equal(expected[:cssy] || expected[:y],    actual[:cssy], "image #{n} - unexpected cssy")
        assert_equal(expected[:cssw] || actual[:width],  actual[:cssw], "image #{n} - unexpected cssw")
        assert_equal(expected[:cssh] || actual[:height], actual[:cssh], "image #{n} - unexpected cssh")
      end
    end

    #--------------------------------------------------------------------------

  end # class LayoutTest
end # module SpriteFactory

