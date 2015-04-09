$LOAD_PATH.unshift '../lib'
require 'simple-server'

SimpleServer.set :root, File.dirname(__FILE__)
SimpleServer.set :default_host, 'a.local'

run SimpleServer