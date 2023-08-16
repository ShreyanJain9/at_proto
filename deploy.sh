#!/bin/bash

# get the version number from lib/at_proto/version.rb
VERSION=$(cat lib/at_proto/version.rb | grep VERSION | awk '{ print $3 }' | tr -d '"')

# prompt for confirmation and new version number
read -p "Are you sure you want to release version $VERSION? [y/n]: " CONFIRM
if [ "$CONFIRM" == "n" ]; then
    echo "Aborting release process."
    exit 1
fi

read -p "Enter new version number (leave blank to keep $VERSION): " NEW_VERSION
if [ -n "$NEW_VERSION" ]; then
    echo "Updating version number to $NEW_VERSION."
    sed -i '' "s/VERSION = \"$VERSION\"/VERSION = \"$NEW_VERSION\"/" lib/at_proto/version.rb
    VERSION=$NEW_VERSION
fi

# build the gem
echo "Building gem..."
gem build at_proto.gemspec

# push the gem to RubyGems
read -p "Push gem to RubyGems? [y/n]: " PUSH_GEM
if [ "$PUSH_GEM" == "y" ]; then
    echo "Pushing gem to RubyGems..."
    gem push at_proto-$VERSION.gem
fi
