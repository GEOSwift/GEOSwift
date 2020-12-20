#!/bin/bash
set -evo pipefail

if [[ $TRAVIS_OS_NAME = 'osx' && $USE_SPM != 'true' ]]; then
  brew upgrade swiftlint
  gem install xcpretty
fi

if [[ $TRAVIS_OS_NAME = 'linux' ]]; then
  wget -N -P ./swift/ https://swift.org/builds/swift-5.3.2-release/ubuntu1804/swift-5.3.2-RELEASE/swift-5.3.2-RELEASE-ubuntu18.04.tar.gz
  tar xzf swift/swift-5.3.2-RELEASE-ubuntu18.04.tar.gz
fi
