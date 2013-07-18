# www.iamnayr.com

This is the source code for my personal website built on the Jekyll platform.  It uses the [Mina](https://github.com/nadarei/mina) gem to deploy to production server in just under 4 seconds.

I've gone with [Digital Ocean](http://digitalocean.com) for hosting as it is very performant for the cost, $5.  

## Installation
`bundle`
Then have jekyll build the site
`jekyll build`

## Deploy
First configure the `config/deploy.rb` file to match your enviornment, then run a `mina setup` followed by `mina deploy`.  

## Notes
I'm running Nginx as my webserver along with the [pagespeed module](https://github.com/pagespeed/ngx_pagespeed).
