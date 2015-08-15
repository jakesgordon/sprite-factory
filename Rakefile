require 'rake/testtask'

#------------------------------------------------------------------------------

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

#------------------------------------------------------------------------------

desc "run a console with SpriteFactory loaded"
task :console do
  system "irb -r #{File.expand_path('lib/sprite_factory', File.dirname(__FILE__))}"
end

#------------------------------------------------------------------------------

desc "regenerate test reference images"
task :reference do

  require File.expand_path('lib/sprite_factory', File.dirname(__FILE__))

  regenerate = lambda do |input, options = {}, &block|
    output = options[:output] || input
    SpriteFactory.run!(input, {:report => true}.merge(options), &block)
    FileUtils.mv(output + "." + (                   :png).to_s, 'test/images/reference')
    FileUtils.mv(output + "." + (options[:style] || :css).to_s, 'test/images/reference')
  end

  regenerate.call('test/images/regular')
  regenerate.call('test/images/regular', :output => 'test/images/regular.horizontal', :selector => 'img.horizontal_', :layout => :horizontal)
  regenerate.call('test/images/regular', :output => 'test/images/regular.vertical',   :selector => 'img.vertical_',   :layout => :vertical)
  regenerate.call('test/images/regular', :output => 'test/images/regular.packed',     :selector => 'img.packed_',     :layout => :packed, :padding => 10, :margin => 10)
  regenerate.call('test/images/regular', :output => 'test/images/regular.padded',     :selector => 'img.padded_',     :padding => 10)
  regenerate.call('test/images/regular', :output => 'test/images/regular.margin',     :selector => 'img.margin_',     :margin => 10)
  regenerate.call('test/images/regular', :output => 'test/images/regular.fixed',      :selector => 'img.fixed_',      :width => 100, :height => 100)
  regenerate.call('test/images/regular', :output => 'test/images/regular.sassy',      :selector => 'img.sassy_',      :style => :sass)

  regenerate.call('test/images/irregular')
  regenerate.call('test/images/irregular', :output => 'test/images/irregular.horizontal', :selector => 'img.horizontal_', :layout => :horizontal)
  regenerate.call('test/images/irregular', :output => 'test/images/irregular.vertical',   :selector => 'img.vertical_',   :layout => :vertical)
  regenerate.call('test/images/irregular', :output => 'test/images/irregular.packed',     :selector => 'img.packed_',     :layout => :packed, :padding => 10, :margin => 10)
  regenerate.call('test/images/irregular', :output => 'test/images/irregular.padded',     :selector => 'img.padded_',     :padding => 10)
  regenerate.call('test/images/irregular', :output => 'test/images/irregular.margin',     :selector => 'img.margin_',     :margin => 10)
  regenerate.call('test/images/irregular', :output => 'test/images/irregular.fixed',      :selector => 'img.fixed_',      :width => 100, :height => 100)
  regenerate.call('test/images/irregular', :output => 'test/images/irregular.sassy',      :selector => 'img.sassy_',      :style => :sass)

  regenerate.call('test/images/hover', :output => 'test/images/hover', :selector => 'div.hover ', :style => :css)
  regenerate.call('test/images/glob',  :output => 'test/images/glob', :glob => "included*")

  regenerate.call('test/images/custom', :output => 'test/images/custom') do |images|
    rules = []
    rules << "div.running img.button { cursor: pointer; #{images[:running][:style]} }"
    rules << "div.stopped img.button { cursor: pointer; #{images[:stopped][:style]} }"
    rules.join("\n")
  end

  regenerate.call('test/images/formats', :library => :rmagick)

end

#------------------------------------------------------------------------------

desc "convert reference test sass files to css"
task :sass do

  `sass 'test/images/reference/regular.sassy.sass'   'test/images/reference/regular.sassy.css'`
  `sass 'test/images/reference/irregular.sassy.sass' 'test/images/reference/irregular.sassy.css'`

end

#------------------------------------------------------------------------------

