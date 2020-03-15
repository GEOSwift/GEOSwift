#!/bin/bash
set -evo pipefail

if [[ $RUN_CODECOV = 'true' ]]; then
  bash <(curl -s https://codecov.io/bash) -J '^GEOSwift$';
fi
