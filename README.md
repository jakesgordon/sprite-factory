Sprite Factory
==============

The sprite factory is a ruby library that can be used to generate
[CSS sprites](http://www.alistapart.com/articles/sprites). It combines
individual image files from a directory into a single unified sprite image
and creates an appropriate CSS stylesheet for use in your web application.

The library provides:

 * both a ruby API and a command line script
 * many customizable options
 * support for any stylesheet syntax, including [CSS](http://www.w3.org/Style/CSS/) and [Sass](http://sass-lang.com/).
 * support for any image library, including [RMagick](http://rmagick.rubyforge.org/) and [ChunkyPNG](https://github.com/wvanbergen/chunky_png).


Installation
============

<code>
$ gem install sprite-factory
</code>

An image library is also required. SpriteFactory comes with built in support for
[RMagick](http://rmagick.rubyforge.org/) or
[ChunkyPng](https://github.com/wvanbergen/chunky_png) and is easily extensible to
use any image library of your choice. 

_(see below for instructions to install an image library if you don't already have one.)_

Usage
=====

Use the `sf` command line script specifying the location of your images.

<code>
$ sf images/icons
</code>

This will combine the individual image files within that directory and generate:

 * images/icons.png
 * images/icons.css

You can also use the SpriteFactory class directly from your own code:

<code language='ruby'>
  require 'sprite_factory'

  SpriteFactory.run!('images/icons')

</code>

The original image name is used for the CSS class to show that image in HTML:

<code language='html'>
  <img src='s.gif' class='high'>
  <img src='s.gif' class='medium'>
  <img src='s.gif' class='low'>
</code>

When using a framework such as Rails, you would usually DRY this up with a helper method:

<code language='ruby'>
  def sprite_tag(name)
    image_tag('s.gif', :class => name)
  end
</code>

Customization
=============

Much of the behavior can be customized by overriding the following options:

 - `:output`   - specify output location for generated files
 - `:layout`   - specify layout algorithm (horizontal or vertical)
 - `:style`    - specify output style (css or sass)
 - `:library`  - specify image library to use (rmagick or chunkypng)
 - `:selector` - specify custom css selector (see below)
 - `:csspath`  - specify custom path for css image url (see below)
 - `:padding`  - add padding to each sprite
 - `:width`    - fix width of each sprite to a specific size
 - `:height`   - fix height of each sprite to a specific size

Options can be passed as command line arguments to the `sf` script:

<code>
$ sf images/icons --style sass --layout vertical
</code>

Options can also be passed as the 2nd argument to the `#run!` method:

<code language='ruby'>
  SpriteFactory.run!('images/icons', :style => :sass, :layout => :vertical)
</code>

You can see the results of many of these options by viewing the sample page that
comes with the gem in `test/images/reference/index.html`.

Customizing the CSS Selector
============================

By default, the CSS generated is fairly simple. It assumes you will be using `<img>`
elements for your sprites, and that the basename of each individual file is suitable for
use as a CSS classname. For example:

<code language='css'>
img.high   { width: 16px; height: 16px; background: url(images/icons.png)   0px 0px no-repeat; }
img.medium { width: 16px; height: 16px; background: url(images/icons.png) -16px 0px no-repeat; }
img.low    { width: 16px; height: 16px; background: url(images/icons.png) -32px 0px no-repeat; }
</code>

If you want to use different selectors for your rules, you can provide the `:selector` option. For
example:

<code language='ruby'>
  SpriteFactory.run!('images/icons', :selector => 'span.icon_')
</code>

will generate:

<code language='css'>
span.icon_high   { width: 16px; height: 16px; background: url(images/icons.png)   0px 0px no-repeat; }
span.icon_medium { width: 16px; height: 16px; background: url(images/icons.png) -16px 0px no-repeat; }
span.icon_low    { width: 16px; height: 16px; background: url(images/icons.png) -32px 0px no-repeat; }
</code>

Customizing the CSS Image Path
==============================

Within the generated CSS file, it can be tricky to get the correct path to your unified
sprite image. For example, you might be hosting your images on Amazon S3, or if you are
building a Ruby on Rails application you might need to generate URL's using the `#image_path`
helper method to ensure it gets the appopriate cache-busting query parameter.

By default, the SpriteFactory generates simple url's that contain only the basename of the
unified sprite image, but you can control the generation of these url's using the :csspath
option:

For most CDN's, you can prepend a simple string to the image name:

<code language='ruby'>
  SpriteFactory.run('images/icons',
                    :csspath => "http://s3.amazonaws.com/")

  # generates:  url(http://s3.amazonaws.com/icons.png)
</code>

For more control, you can provide a lambda function and generate your own paths:

<code language='ruby'>
  SpriteFactory.run('images/icons',
                     :csspath => lambda{|image| image_path(image)})

  # generates:   url(/images/icons.png?v123456)
</code>

Customizing the entire CSS output 
=================================

If you want **complete** control over the generated styles, you can pass a block to the `run!` method.

The block will be provided with information about each image, including the generated css attributes. 
Whatever content the block returns will be inserted into the generated css file.

<code language='ruby'>
  SpriteFactory.run!('images/timer') do |images|
    rules = []
    rules << "div.running img.button { cursor: pointer; #{images[:running][:style]} }"
    rules << "div.stopped img.button { cursor: pointer; #{images[:stopped][:style]} }"
    rules.join("\n")
  end
</code>

The `images` argument is a hash, where each key is the basename of an image file, and the
value is a hash of image metadata that includes the following:

 * `:style`  - the default generated style
 * `:cssx`   - the css sprite x position
 * `:cssy`   - the css sprite y position
 * `:cssw`   - the css sprite width
 * `:cssh`   - the css sprite height
 * `:x`      - the image x position
 * `:y`      - the image y position
 * `:width`  - the image width
 * `:height` - the image height

(*NOTE*: the image coords can differ form the css sprite coords when padding or fixed width/height options are specified)

Extending the Library
=====================

The sprite factory library can also be extended in a number of other ways.

 * provide a custom layout algorithm in the `SpriteFactory::Layout` module.
 * provide a custom style generator in the `SpriteFactory::Style` module.
 * provide a custom image library in the `SpriteFactory::Library` module.

_(see existing code for examples of each)._

Installing an Image Library
===========================

SpriteFactory comes with built in support for
[RMagick](http://rmagick.rubyforge.org/) or
[ChunkyPng](https://github.com/wvanbergen/chunky_png)

RMagick is the most flexible image libary to use, but requires ImageMagick
binaries, installation instructions for ubuntu:

<code>
$ sudo aptitude install imageMagick libMagickWand-dev
$ sudo gem install rmagick
</code>

ChunkyPng is lighter weight and has no binary requirements, but only supports
.png format. Installation is a simple gem install:

<code>
$ gem install chunky_png
</code>

SpriteFactory can also be easily extended to use the image library of your choice.

License
=======

See LICENSE file.

Contact
=======

You can reach me at [jake@codeincomplete.com](mailto:jake@codeincomplete.com), or via
my website: [Code inComplete](http://codeincomplete.com).




