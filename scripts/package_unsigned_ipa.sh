#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${1:-MentalismApp}"
APP_PATH="${2:-DerivedData/Build/Products/Release-iphoneos/${APP_NAME}.app}"
OUTPUT_DIR="${3:-artifacts}"

if [[ ! -d "$APP_PATH" ]]; then
  echo "App bundle not found at: $APP_PATH"
  exit 1
fi

mkdir -p "$OUTPUT_DIR/Payload"
rm -rf "$OUTPUT_DIR/Payload/${APP_NAME}.app"
cp -R "$APP_PATH" "$OUTPUT_DIR/Payload/${APP_NAME}.app"

pushd "$OUTPUT_DIR" >/dev/null
rm -f "${APP_NAME}-unsigned.ipa"
/usr/bin/zip -qry "${APP_NAME}-unsigned.ipa" Payload
popd >/dev/null

echo "Created ${OUTPUT_DIR}/${APP_NAME}-unsigned.ipa"
