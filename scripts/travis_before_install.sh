#!/bin/bash
set -evo pipefail

if [[ $TRAVIS_OS_NAME = 'osx' && $USE_SPM != 'true' ]]; then
  brew upgrade carthage swiftlint
  gem install xcpretty
  carthage update \
    --cache-builds \
    --platform "$PLATFORM" \
    --no-use-binaries
fi

if [[ $TRAVIS_OS_NAME = 'linux' ]]; then
  wget -N -P ./swift/ https://swift.org/builds/swift-5.1.5-release/ubuntu1804/swift-5.1.5-RELEASE/swift-5.1.5-RELEASE-ubuntu18.04.tar.gz
  tar xzf swift/swift-5.1.5-RELEASE-ubuntu18.04.tar.gz
fi
