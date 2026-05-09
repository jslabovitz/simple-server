#encoding: utf-8

Gem::Specification.new do |s|
  s.name          = 'simple-server'
  s.version       = '0.5'
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

  s.add_dependency 'addressable', '~> 2.9'
  s.add_dependency 'path', '~> 2.1'
  s.add_dependency 'sinatra', '~> 4.2'
  s.add_dependency 'puma', '~> 8.0'

  s.add_development_dependency 'rake', '~> 13.4'
  s.add_development_dependency 'simple-rack-tasks', '~> 0.1'
end