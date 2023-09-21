#encoding: utf-8

Gem::Specification.new do |s|
  s.name          = 'simple-server'
  s.version       = '0.4'
  s.summary       = 'A simple web server.'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
    SimpleServer provides a simple web server.
  }
  s.homepage      = 'http://github.com/jslabovitz/simple-server'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'addressable', '~> 2.8'
  s.add_dependency 'path', '~> 2.1'
  s.add_dependency 'sinatra', '~> 3.1'
  s.add_dependency 'puma', '~> 6.4'

  s.add_development_dependency 'bundler', '~> 2.4'
  s.add_development_dependency 'rake', '~> 13.0'
end