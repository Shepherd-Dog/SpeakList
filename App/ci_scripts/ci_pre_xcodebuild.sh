#!/bin/sh

brew install jq
brew install parallel

xcrun simctl list -j "devices" \
  | jq -r '.devices | with_entries(select(.key | contains("iOS"))) | map(.[] | select(.isAvailable == true)) | .[] .udid' \
  | parallel --jobs 4 'echo {}; xcrun simctl boot {}; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLanguages -array en; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLocale -string en_US; xcrun simctl shutdown {};'
