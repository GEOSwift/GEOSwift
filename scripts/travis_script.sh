#!/bin/bash
set -evo pipefail

if [[ $TRAVIS_OS_NAME = 'linux' ]]; then
  export PATH="${PWD}/swift-5.3.2-RELEASE-ubuntu18.04/usr/bin:$PATH"
fi

if [[ $USE_SPM = 'true' ]]; then
  swift test --enable-test-discovery
else
  xcodebuild \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -sdk "$SDK" \
    -destination "$DESTINATION" \
    -configuration Debug \
    ONLY_ACTIVE_ARCH=YES \
    clean test | xcpretty -c;
fi
