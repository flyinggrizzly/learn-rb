require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/unicorn'

require 'uniofbath_deploy'

# load the environment config files
Dir['./config/deployments/*.rb'].each { |f| load f }

set :repository,   'git@github.bath.ac.uk:digital/cms-editor.git'
set :default_server, :staging

set :server, ENV['to'] || default_server
invoke :"env:#{server}"
