require File.expand_path('test_case', File.dirname(__FILE__))

module SpriteFactory
  class StyleTest < SpriteFactory::TestCase

    TEST_ATTRIBUTES = [
      "width: 30px",
      "height: 40px",
      "background: url(path/to/image.png) -10px -20px no-repeat"
    ]

    #--------------------------------------------------------------------------

    def test_css
      expected = "img.foo { width: 30px; height: 40px; background: url(path/to/image.png) -10px -20px no-repeat; }"
      actual   = Style.css("img.", "foo", TEST_ATTRIBUTES)
      assert_equal(expected, actual)
    end

    #--------------------------------------------------------------------------

    def test_scss
      expected = "img.foo { width: 30px; height: 40px; background: url(path/to/image.png) -10px -20px no-repeat; }"
      actual   = Style.scss("img.", "foo", TEST_ATTRIBUTES)
      assert_equal(expected, actual)
    end

    #--------------------------------------------------------------------------

    def test_sass
      expected = "img.foo\n  width: 30px\n  height: 40px\n  background: url(path/to/image.png) -10px -20px no-repeat\n"
      actual   = Style.sass("img.", "foo", TEST_ATTRIBUTES)
      assert_equal(expected, actual)
    end

    #--------------------------------------------------------------------------

    def test_generate

      style    = :css
      selector = 'img.'
      url      = 'url(/path/to/sprite.png)'
      images   = [
        {:filename => '/path/to/sprite1.png', :name => 'sprite1', :cssx => 1, :cssy => 10, :cssw => 100, :cssh => 1000},
        {:filename => '/path/to/sprite2.png', :name => 'sprite2', :cssx => 2, :cssy => 20, :cssw => 200, :cssh => 2000},
        {:filename => '/path/to/sprite3.png', :name => 'sprite3', :cssx => 3, :cssy => 30, :cssw => 300, :cssh => 3000},
        {:filename => '/path/to/sprite4.png', :name => 'sprite4', :cssx => 4, :cssy => 40, :cssw => 400, :cssh => 4000},
        {:filename => '/path/to/sprite5.png', :name => 'sprite5', :cssx => 5, :cssy => 50, :cssw => 500, :cssh => 5000}
      ]

      lines = Style.generate(style, selector, url, images).split("\n")

      assert_equal("width: 100px; height: 1000px; background: url(/path/to/sprite.png) -1px -10px no-repeat", images[0][:style], "pure style should have been stashed away in image[:style] for use by custom rule builders")
      assert_equal("width: 200px; height: 2000px; background: url(/path/to/sprite.png) -2px -20px no-repeat", images[1][:style], "pure style should have been stashed away in image[:style] for use by custom rule builders")
      assert_equal("width: 300px; height: 3000px; background: url(/path/to/sprite.png) -3px -30px no-repeat", images[2][:style], "pure style should have been stashed away in image[:style] for use by custom rule builders")
      assert_equal("width: 400px; height: 4000px; background: url(/path/to/sprite.png) -4px -40px no-repeat", images[3][:style], "pure style should have been stashed away in image[:style] for use by custom rule builders")
      assert_equal("width: 500px; height: 5000px; background: url(/path/to/sprite.png) -5px -50px no-repeat", images[4][:style], "pure style should have been stashed away in image[:style] for use by custom rule builders")

      assert_equal("img.sprite1 { #{images[0][:style]}; }", lines[0], "appropriate rule should have been generated using the pure style stashed away in image[:style]")
      assert_equal("img.sprite2 { #{images[1][:style]}; }", lines[1], "appropriate rule should have been generated using the pure style stashed away in image[:style]")
      assert_equal("img.sprite3 { #{images[2][:style]}; }", lines[2], "appropriate rule should have been generated using the pure style stashed away in image[:style]")
      assert_equal("img.sprite4 { #{images[3][:style]}; }", lines[3], "appropriate rule should have been generated using the pure style stashed away in image[:style]")
      assert_equal("img.sprite5 { #{images[4][:style]}; }", lines[4], "appropriate rule should have been generated using the pure style stashed away in image[:style]")

    end

    #--------------------------------------------------------------------------

  end
end


