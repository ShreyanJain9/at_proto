#!/bin/bash

# get the current version from lib/at_protocol/version.rb
VERSION=`cat lib/at_protocol/version.rb | grep "VERSION =" | cut -d '"' -f 2`
echo "Building gem version $VERSION"

# build the gem
gem build at_protocol.gemspec

# install the gem locally
gem install ./at_protocol-$VERSION.gem
