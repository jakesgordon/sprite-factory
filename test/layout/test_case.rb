require File.expand_path('../test_case', File.dirname(__FILE__))

module SpriteFactory
  module Layout
    class TestCase < SpriteFactory::TestCase

      #==========================================================================
      # layout test helpers
      #==========================================================================

      protected

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

    end # class TestCase
  end # module Layout
end # module SpriteFactory
