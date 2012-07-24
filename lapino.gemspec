# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "lapino"
  s.version     = "0.1.0"
  s.authors     = ["azukiwasher"]
  s.email       = ["azukiwasher@higanworks.com"]
  s.homepage    = ""
  s.summary     = %q{A sinatra-based app that redirects data received via HTTP to an AMQP message broker}
  s.description = %q{A sinatra-based app that redirects data received via HTTP to an AMQP message broker.}

  s.rubyforge_project = "lapino"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rack",        "~> 1.4.0"
  s.add_dependency "bunny",       "~> 0.8.0"
  s.add_dependency "multi_json",  "~> 1.3.0"
  s.add_dependency "sinatra",     "~> 1.3.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "puma"
end
