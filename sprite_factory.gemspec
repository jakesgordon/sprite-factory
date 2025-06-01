# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("lib", File.dirname(__FILE__))
require 'sprite_factory'

Gem::Specification.new do |s|

  s.name        = "sprite-factory"
  s.version     = SpriteFactory::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jake Gordon"]
  s.email       = ["jakesgordon@gmail.com"]
  s.homepage    = "https://github.com/jakesgordon/sprite-factory"
  s.summary     = SpriteFactory::SUMMARY
  s.description = SpriteFactory::DESCRIPTION

  s.add_development_dependency 'rmagick'
  s.add_development_dependency 'chunky_png'

  s.has_rdoc         = false
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.files            = `git ls-files `.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]

end
