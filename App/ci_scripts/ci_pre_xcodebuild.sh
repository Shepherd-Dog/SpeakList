#!/bin/sh

brew install jq
brew install parallel

# xcrun simctl list -j "devices" | jq -r '.devices | map(.[])[].udid' | parallel 'xcrun simctl boot {}; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLanguages -array en; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLocale -string en_US; xcrun simctl shutdown {};'

# xcrun simctl list -j "devices" | jq -r '.devices | with_entries(select(.key | contains("iOS"))) | map(.[]) | .[] .udid' | parallel 'xcrun simctl boot {}; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLanguages -array en; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLocale -string en_US; xcrun simctl shutdown {};'

xcrun simctl list -j "devices" | jq -r '.devices | with_entries(select(.key | contains("iOS"))) | map(.[] | select(.isAvailable == true)) | .[] .udid' | parallel 'xcrun simctl boot {}; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLanguages -array en; xcrun simctl spawn {} defaults write "Apple Global Domain" AppleLocale -string en_US; xcrun simctl shutdown {};'

exit 0

SIMULATOR_NAME="iPhone 15 Pro"
LOCALE="en_US"

exit_if_no_simulator() {
  SIMULATOR_ID=$( get_uid )
  if [ -z "$SIMULATOR_ID" ]
  then
    echo "No simulator with name [$SIMULATOR_NAME]"
    exit -1
  fi
}

get_uid() {
  echo $( xcrun simctl list | grep -w "$SIMULATOR_NAME" | awk 'match($0, /\(([-0-9A-F]+)\)/) { print substr( $0, RSTART + 1, RLENGTH - 2 ); exit}' )
}

get_status () {
  echo $(xcrun simctl list | grep -w "$SIMULATOR_NAME" | awk 'match($0, /\(([a-zA-Z]+)\)/) { print substr( $0, RSTART + 1, RLENGTH - 2 ); exit}')
}

set_locale() {
  LOCALE=$1

  if [ -z $LOCALE ]
  then
    echo "Locale has to be provided. Example:
  ./scripts/simulator.sh boot iphone7_snapshots uk_UA"
    exit -1
  fi

  SIMULATOR_ID=$( get_uid )
  PLIST_FILE="$HOME/Library/Developer/CoreSimulator/Devices/$SIMULATOR_ID/data/Library/Preferences/.GlobalPreferences.plist"
  echo "PLIST FILE: $PLIST_FILE"
  echo "Setting locale: $LOCALE"
  exit_if_no_simulator
  plutil -replace AppleLocale -string $LOCALE $PLIST_FILE
  plutil -replace AppleLanguages -json "[ \"$LOCALE\" ]" $PLIST_FILE
  # plutil -replace AppleKeyboards -json '[ "uk_UA@sw=Ukrainian;hw=Automatic" ]' $PLIST_FILE
}

shutdown () {
  SIMULATOR_ID=$( get_uid )
  RETRY_DELAY=5
  retry_cnt=10

  if [ -z $SIMULATOR_ID ]
  then
    return
  fi

  for (( ; ; ))
  do
    SIMULATOR_STATUS=$(get_status)

    if [ $SIMULATOR_STATUS = "Shutdown" ]
    then
      break
    elif [ $SIMULATOR_STATUS = "Booted" ]
    then
      xcrun simctl shutdown $SIMULATOR_ID
    else
      echo "Retrying in $RETRY_DELAY seconds, status is [$SIMULATOR_STATUS]"
    fi

    if [ $retry_cnt = 0 ]
    then
      echo "Cannot shutdown simulator $SIMULATOR_ID"
      exit -1
    fi
    retry_cnt=$((retry_cnt - 1))
    sleep $RETRY_DELAY
  done
}

boot () {
  SIMULATOR_ID=$( get_uid )
  exit_if_no_simulator
  xcrun simctl boot $SIMULATOR_ID
}

set_locale $LOCALE
shutdown
boot
