#!/bin/sh

# Enable all the macros to run on CI
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

brew install swift-format

if [[ $CI_XCODEBUILD_ACTION == "test-without-building" ]]
then
  # Setup the simulators so that they only have one preferred language.
  # This works around an issue where the simulators on Sonoma have multiple
  # preferred languages which include Arabic and therefore provide different
  # results when running snapshot tests.
  #
  # This solution was inspired by: https://stackoverflow.com/a/74335552
  brew install jq
  brew install parallel

  # In my testing running more than 2 jobs in parallel led to flaky tests
  # where the simulators would error out.
  xcrun simctl list -j "devices" \
    | jq -r '.devices | with_entries(select(.key | contains("iOS"))) | map(.[] | select(.isAvailable == true)) | .[] .udid' \
    | parallel --jobs 2 'echo {}; xcrun simctl boot {}; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLanguages -array en; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLocale -string en_US; xcrun simctl shutdown {};'
fi
