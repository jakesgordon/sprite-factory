require File.expand_path('test_case', File.dirname(__FILE__))

module SpriteFactory
  module Layout
    class VerticalTest < SpriteFactory::Layout::TestCase

      #==========================================================================
      # test REGULAR images
      #==========================================================================

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

      def test_margin_vertical_layout_of_regular_images
        images = get_regular_images
        expected = [
          { :cssx => 10, :cssy =>  20, :cssw => 20, :cssh => 10, :x => 10, :y =>  20 },
          { :cssx => 10, :cssy =>  70, :cssw => 20, :cssh => 10, :x => 10, :y =>  70 },
          { :cssx => 10, :cssy => 120, :cssw => 20, :cssh => 10, :x => 10, :y => 120 },
          { :cssx => 10, :cssy => 170, :cssw => 20, :cssh => 10, :x => 10, :y => 170 },
          { :cssx => 10, :cssy => 220, :cssw => 20, :cssh => 10, :x => 10, :y => 220 }
        ]
        verify_layout(40, 250, expected, images, :layout => :vertical, :hmargin => 10, :vmargin => 20)
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

      def test_margin_vertical_layout_of_irregular_images
        images = get_irregular_images
        expected = [
          { :cssx => 50, :cssy =>  20, :cssw =>  20, :cssh => 50, :x => 50, :y =>  20 },
          { :cssx => 40, :cssy => 110, :cssw =>  40, :cssh => 40, :x => 40, :y => 110 },
          { :cssx => 30, :cssy => 190, :cssw =>  60, :cssh => 30, :x => 30, :y => 190 },
          { :cssx => 20, :cssy => 260, :cssw =>  80, :cssh => 20, :x => 20, :y => 260 },
          { :cssx => 10, :cssy => 320, :cssw => 100, :cssh => 10, :x => 10, :y => 320 }
        ]
        verify_layout(120, 350, expected, images, :layout => :vertical, :hmargin => 10, :vmargin => 20)
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

      #--------------------------------------------------------------------------

    end # class VerticalTest
  end # module Layout
end # module SpriteFactory

