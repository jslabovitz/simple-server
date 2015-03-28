#encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simple-server'

Gem::Specification.new do |s|
  s.name          = 'simple-server'
  s.version       = SimpleServer::VERSION
  s.summary       = 'A simple web server.'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
    SimpleServer provides a simple web server.
  }
  s.homepage      = 'http://github.com/jslabovitz/mill'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'addressable'
  s.add_dependency 'path'
  s.add_dependency 'sinatra'
  s.add_dependency 'puma'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end