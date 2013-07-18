require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)

set :domain, 'iamnayr.com'
set :deploy_to, '/var/www/iamnayr.com'
set :repository, 'git://github.com/thenayr/iamnayr.com.git'
set :branch, 'remove-unicorn'

# Optional settings:
    set :user, 'deployer'    # Username in the server to SSH to.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rvm:use[ruby-1.9.3-p194@nayr]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  #queue! %[mkdir -p "#{deploy_to}/shared/log"]
  #queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  #queue! %[mkdir -p "#{deploy_to}/shared/config"]
  #queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  #queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  #queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'bundle:install'
    queue "#{bundle_prefix} jekyll build"

    to :launch do
      #queue "jekyll build"
      #queue "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end

