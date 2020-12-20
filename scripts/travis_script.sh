#!/bin/bash
set -evo pipefail

if [[ $TRAVIS_OS_NAME = 'linux' ]]; then
  export PATH="${PWD}/swift-5.3.2-RELEASE-ubuntu18.04/usr/bin:$PATH"
fi

if [[ $TRAVIS_OS_NAME = 'osx' ]]; then
  swiftlint
fi

if [[ $USE_SPM = 'true' ]]; then
  swift test --enable-test-discovery
else
  rm -rf GEOSwift.xcodeproj
  xcodebuild \
    -scheme GEOSwift \
    -sdk "$SDK" \
    -destination "$DESTINATION" \
    clean test | xcpretty -c;
fi
