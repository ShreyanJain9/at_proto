#!/bin/bash

# get the current version from lib/at_proto/version.rb
VERSION=`cat lib/at_proto/version.rb | grep "VERSION =" | cut -d '"' -f 2`
echo "Building gem version $VERSION"

# build the gem
gem build at_proto.gemspec

# install the gem locally
gem install ./at_proto-$VERSION.gem
