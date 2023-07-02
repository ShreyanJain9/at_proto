#!/bin/bash

# get the current version from lib/atmosfire/version.rb
VERSION=`cat lib/atmosfire/version.rb | grep "VERSION =" | cut -d '"' -f 2`
echo "Building gem version $VERSION"

# build the gem
gem build atmosfire.gemspec

# install the gem locally
gem install ./atmosfire-$VERSION.gem
