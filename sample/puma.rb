#!/usr/bin/env puma

environment 'production'
daemonize true
pidfile 'puma.pid'
state_path 'puma.state'
stdout_redirect 'output.log', 'output.log', true
# quiet
threads 3, 16
bind 'tcp://0.0.0.0:9292'