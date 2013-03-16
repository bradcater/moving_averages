# -*- encoding: utf-8 -*-
require File.expand_path('../lib/moving_average/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brad Cater"]
  gem.email         = ["bradcater@gmail.com"]
  gem.description   = %q{This gem adds methods to the Array class to compute different types of moving averages.}
  gem.summary       = %q{This gem adds methods to the Array class to compute different types of moving averages.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "moving_average"
  gem.require_paths = ["lib"]
  gem.version       = MovingAverage::VERSION

  gem.add_development_dependency "rspec", "~> 2.13"

end
