---
layout: post
title: "How I deploy my Jekyll blog to Digital Ocean in under 5 seconds"
categories: tutorials
date: 2013-07-21 10:29:21 -0700
type: post
---
##Blazing fast Jekyll blog deploys using Mina
For the latest iteration of my blog, I knew I wanted to be able to deploy quickly and efficiently as well as have complete control over all aspects of my server and keep the bill very inexpensive.  For these reasons I knew migrating away from Heroku was unavoidable.  This is the result:
<div class="image-wrap">
<img width="650" height="526" src="http://cdn.iamnayr.com/2013/07/mina-deploy.gif" alt="Mina deploy in 2 seconds"/>
</div>
I'd been running my blog on Heroku's free edition for some time and had a rather hacked together solution for managing to get Jekyll to run on there that included several Gems, a sub-par unicorn / rack combination and a few other weird things. 

Just to be clear, this isn't a Heroku bashing post, I have nothing bad to say about them, I just knew I could get a lot more bang for my buck elsewhere and much prefer the control of managing my own servers. I had heard quite the murmor about [Digital Ocean](https://www.digitalocean.com/?refcode=7349251230a0) (full disclosure I'm an affiliate, non affiliate link here - [Digital Ocean](http://www.digitalocean.com)) and the $5 price point really helped make the decision a no-brainer, ironically enough they did have a short outage while I was writing this tutorial, but they are very quick to respond and notify customers of problems very quickly, the site was only down for ~10 minutes.

My full time job involves deploying a lot of large scale and complex Rails applications, which typically consists of various scripts all being triggered through [Capistrano](https://github.com/capistrano/capistrano).  Capistrano is fantastic, but overall felt a bit too heavy handed for what I was doing, essentially deploying static files to a remote server.  Enter [Mina](http://nadarei.co/mina/) (side note, I really have no idea how I should pronounce Mina.  "Minna" or maybe "Mine-a"), a super fast, lightweight and powerful deployment utility.  Check out this logo:

<div class="image-wrap">
<img width="175" height="194" src="http://cdn.iamnayr.com/2013/07/mina-logo.png" alt="Mina logo is awesome!" />
</div>

That logo alone was reason enough for me to give it a shot, it looks like a flippin' super villains chest piece.  Other promising aspects of Mina included:

- Only ONE SSH session per deploy, compared to one session per COMMAND on Capistrano
- Built on top of the already familiar Rake
- Safe and bloody fast

Convinced yet?  I certainly am, that's why I'm writing this tutorial.  Creating an account with Digital Ocean is dead simple,  make sure you [setup and add your SSH key](https://www.digitalocean.com/community/articles/how-to-set-up-ssh-keys--2) to allow for easier deployments. It's slightly outside the scope of this tutorial, so read the D.O. guide if you are having trouble.  I may consider writing an A-Z type tutorial later on.

##Notes before we begin
I much prefer to manage my ruby versions using [RVM](http://rvm.io/), although that isn't a requirement for this to work by any means, I will be using it in this guide.  I'm also not going to go too much into using [Jekyll](http://jekyllrb.com/), as I'm going to assume you already have an idea of how it works, or possibly are already using it.  Also might be worth noting that my client machine is a MacBook Air running the latest OSX 10.8.4, although there is absolutely no reason it wouldn't work anywhere.  My Digital Ocean droplet is running Ubuntu 12-04, I prefer [Nginx](http://nginx.org/) as my webserver and it works fantastically well in combination with Jekyll to quickly and easily serve static files. I plan on writing a complete tutorial on using [Ansible](http://ansibleworks.com/) to do the initial server provisioning as well.

##Configure your Jekyll blog to use mina
As noted before, I use RVM and Gemfile's to simplify my projects and gem management.  Here is the `Gemfile` for my Jekyll blog:

{% prism ruby %}
#Gemfile
source :rubygems
gem "rake"                # actually not need for heroku but for the provided Rakefile
gem "activesupport", "~> 3.2.11"
gem "flickraw", "~> 0.9.6"
gem "RedCloth"            # if you want to use the Textile Markup Language
gem "redcarpet"
gem "jekyll", "1.0.3" # we need at least this version so jekyll will use Ruby 1.9.2
gem "pygmentize", "~> 0.0.3"
gem "mina", "0.3.0"
{% endprism %}

The latest version of mina as of writing is "0.3.0".  To "minatize" our blog, make sure you `bundle` to install the gems, then run `bundle exec mina init`. This will create a ./config/deploy.rb file.  This is just a Rake file with tasks for mina to run.  Let's look at a boilerplate mina deploy.rb file:

{% prism ruby %}
# New config/deploy.rb file
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'foobar.com'
set :deploy_to, '/var/www/foobar.com'
set :repository, 'git://...'
set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

{% endprism %}

As you can see there is a bunch of commented out boilerplate syntax to help you get started, the general idea is similar to Capistrano, you define a github branch, domain, username and deployment location, the gem creates a script using all of your variables.  The boilerplate syntax is more suited to deployment of a Rails application, which for us is a bit overkill.  Here is the simplified version specific to my Jekyll blog:

{% prism ruby %}
# Jekyll blog config/deploy.rb file
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)

set :domain, 'iamnayr.com'
set :deploy_to, '/var/www/iamnayr.com'
set :repository, 'git://github.com/thenayr/iamnayr.com.git'
set :branch, 'master'

# Optional settings:
set :user, 'deployer'    # Username in the server to SSH to.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rvm:use[ruby-1.9.3-p194@nayr]'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'bundle:install'
    queue "#{bundle_prefix} jekyll build"
  end
end
{% endprism %}

Much more straightforward.  The line `set :user, 'deployer'` should be modified to match the user you use to SSH into your server, don't forget to modify `set :domain`, `set :deploy_to` and `set :repository` to all align with your enviornment. Note that the syntax highlighting library messes up around line 28, that isn't a commented line, it's using the ruby `#{}` syntax to expand the bundle_prefix directory.

The enivornment task tells mina that I want to load RVM into the enviorment before executing the scripts.  This is important because I have Jekyll installed in a Gemset called "nayr" that has to be loaded before I can run the `jekyll build` command.  Mina provides a nice helper called `bundle_prefix` to make it easy to run commands that have to be prefixed with the `bundle exec` keywords.

{% prism ruby %}
task :environment do
  invoke :'rvm:use[ruby-1.9.3-p194@nayr]'
end
{% endprism %}

The deploy task clones the latest version of my blog down, runs a bundle install to see if I added any gem requirements, then builds the Jekyll blog:

{% prism ruby %}
desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'bundle:install'
    queue "#{bundle_prefix} jekyll build"
  end
end
{% endprism %}

Now anytime you are finished writing a post locally, commit and push it to github, then when you are ready for it to go live a simple `mina deploy` in your local directory will trigger the deployment to your remote server.

##Wrapping up

Again let me stress that this is a very light usage of mina, which is precisely what I wanted.  Mina keeps everything clean and organized on the server side with several directories `/var/www/iamnayr.com/current`, `/var/www/iamnayr.com/last_version`, `/var/www/iamnayr.com/releases`.  These are part of the fail safe process and make rollbacks to previous versions very easy.  I also have the flexibility to add queue up new commands whenever necessary.

Let's take a peek at my nginx virtual host file:

{% prism bash %}
# Nginx /etc/nginx/sites-enabled/iamnayr.com file

server {

  listen 80;
  server_name www.iamnayr.com;
  root /var/www/iamnayr.com/current/_site;
  error_log /etc/nginx/log/iamnayr.com_error.log;
  access_log /etc/nginx/log/iamnayr.com_access.log;

  error_page 404 = /404.html;
  error_page 403 = /404.html;

  location ~* \.(css|js|gif|jpeg|png)$ {
      expires 7d;
      add_header Pragma public;
      add_header Cache-Control "public, must-revalidate, proxy-revalidate";
  }

}

server {
  listen 80;
  server_name iamnayr.com;
  rewrite ^ http://www.iamnayr.com$request_uri? permanent;
}
{% endprism %}

It's a very standard Nginx static file virtual host file, I point to Jekyll's built site directory `_site`.  404's are managed by using an `error_page 404 = /404.html` directive. I prefer www to non-www so I do a permanent redirect to those pages as well.

I encourage you to look at the [full source code of my blog on github](https://github.com/thenayr/iamnayr.com).  Deploying and managing a Jekyll blog is incredibly straightforward and fun :)  I much prefer writing my articles straight in the command line and using mina for deployments means I don't have to lift a hand to go from drafting, to publishing to deployment. It's very fast and satisfies my hacker needs.

Please [contact me](mailto:iamnayr@gmail.com?Subject=Suggestions) if you have any suggestions for improvement!
