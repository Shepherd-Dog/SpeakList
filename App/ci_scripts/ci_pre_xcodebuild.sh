#!/bin/sh

if [[ $CI_XCODEBUILD_ACTION == "test-without-building" ]]
  # Setup the simulators so that they only have one preferred language.
  # This works around an issue where the simulators on Sonoma have multiple
  # preferred languages which include Arabic and therefore provide different
  # results when running snapshot tests.
  #
  # This solution was inspired by: https://stackoverflow.com/a/74335552
  brew install jq
  brew install parallel

  xcrun simctl list -j "devices" \
    | jq -r '.devices | with_entries(select(.key | contains("iOS"))) | map(.[] | select(.isAvailable == true)) | .[] .udid' \
    | parallel --jobs 2 'echo {}; xcrun simctl boot {}; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLanguages -array en; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLocale -string en_US; xcrun simctl shutdown {};'
fi
