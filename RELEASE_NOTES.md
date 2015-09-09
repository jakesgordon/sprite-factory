September 9th 2015 - v1.7.1
---------------------------

 * added `exclude` option to ignore select images in source directory (courtesy of @AlexanderRD)

August 15th 2015 - v1.7
-----------------------

 * added `sanitizer` option to give more control over converting non-standard filenames to css selectors (hattip to @MentalPower)
 * rename `directory_separator` option to simpler `separator`
 * switch to minitest 
 * replace deprecated require 'RMagick' with require 'rmagick' (courtesy of @warrenguy)
 * added `:glob` option to override default globbing behavior (courtsey of @jdlich)

January 17th 2015 - v1.6.2
--------------------------

 * replace deprecated Magick::MaxRGB with Magick::QuantumRange (courtesy of @kenmicles)
 * add option to override default directory separator (courtesy of @cotampanie)

August 8th 2014 - v1.6.1
------------------------

 * correct escaping for filenames passed to pngcrush (courtesy of @phallstrom - Cheers!)
 * suppress pngcrush output with -q (courtesy of @phallstrom - Cheers!)

March 16th 2014 - v1.6.0
------------------------

 * Added raw ImageMagick driver can be used without RMagick gem (courtesy of @willglynn - Cheers!)
 * Exposed `padding` and `margin` support to the cli interface (courtesy of @miguelgonz - Cheers!)


February 21st 2013 - v1.5.3
---------------------------
 * bugfix: added back `:selector` when providing attributes for custom style generators (it was accidentally removed in v1.5.2)

January 13th 2013 - v1.5.2
--------------------------
 * replaced `:csspath` option with `:cssurl` [issue #21](https://github.com/jakesgordon/sprite-factory/issues/21)
 * ordered css rules by pseudoclass importance [issue #20](https://github.com/jakesgordon/sprite-factory/pull/20)
 * added support for .ico files when using rmagick [issue #18](https://github.com/jakesgordon/sprite-factory/pull/18)

June 11th 2012 - v1.5.1
-----------------------
 * added a new `:return => :images` option for callers that want access to the detailed `images` hash instead of the generated css content

May 10th 2012 - v1.5.0
----------------------
 * @halida added a new `margin` option to (optionally) separate images in generated spritesheet to avoid 'bleeding' when browser scales the sprite (e.g. when user increases text size)
 * added `padding` support for `packed` layout
 * added `margin` support for `packed` layout
 * added support for using source image filename as automatic css selector [issue #12](https://github.com/jakesgordon/sprite-factory/issues/12)
 * added support for `:hover` (and other pseudo-class) selectors [issue #14](https://github.com/jakesgordon/sprite-factory/issues/14)

February 29th 2012 - v1.4.2
---------------------------
 * added support for `:nocomments => true` to suppress comments in generated output stylesheet
 * added support for images in subfolders - fixes [github issue #11](https://github.com/jakesgordon/sprite-factory/issues/11)

August 5th 2011 - v1.4.1
------------------------
 * added support for `:style => :scss` to generate .scss file (even though content will be almost exactly same as .css style)
 * deprecated `:output` option and replaced it with 2 new explicit `:output_image` and `:output_style` options
 * updated RELEASE NOTES to include setup for use with Rails 3.1 asset pipeline

Auguest 5th 2011 - v1.4.0
-------------------------
 * (not available)

July 9th 2011 - v1.3.0
----------------------

 * source image file extensions now treated in case INsensitive manner (e.g. we detect both .PNG, .png and .Png)
 * added `:nocss => true` option to suppress generation of output css file (caller should use `run!` return value instead - it contains the generated css content as a string)

May 8th 2011 - v1.2.0
---------------------

 * added new `:layout => :packed` option to use bin-packing algorithm for generating rectangular sprite sheet
 * added pngcrush support

April 29th 2011 - v1.0.0
------------------------

 * original version
