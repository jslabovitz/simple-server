$LOAD_PATH.unshift '../lib'
require 'simple-server'

SimpleServer.set :root, File.dirname(__FILE__) + '/sites'
SimpleServer.set :default_host, 'localhost'

run SimpleServer