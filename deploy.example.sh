#!/bin/bash

# Provide cron with the chruby environment as seen in `/etc/profile.d/chruby.sh`.
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

cd /path/to/git/repository/;

# For now, we just assume to be on the right branch for our website. TODO: throw an error if not.
git pull;

LC_ALL="en_US.UTF-8" bundle exec middleman build --clean;

# Add URL forwarders, password protection etc.
# (.htaccess gets deleted during a Middleman build.)
cp -a source/.htaccess build/.htaccess

