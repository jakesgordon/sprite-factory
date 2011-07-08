
v1.3.0 (unreleased)
-------------------

 * source image file extensions now treated in case INsensitive manner (e.g. we detect both .PNG, .png and .Png)
 * added `:nocss => true` option to suppress generation of output css file (caller should use `run!` return value instead - it contains the generated css content as a string)

May 8th 2011 - v1.2.0
---------------------

 * added new `:layout => :packed` option to use bin-packing algorithm for generating rectangular sprite sheet

May 1st 2011 - v1.0.1
---------------------

 * added pngcrush support

April 29th 2011 - v1.0.0
------------------------

 * original version
