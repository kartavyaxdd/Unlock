#!/usr/bin/env bash
set -euo pipefail

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "XcodeGen is required. Install it first: brew install xcodegen"
  exit 1
fi

xcodegen generate
echo "Project generated. Open MentalismApp.xcworkspace in Xcode."
