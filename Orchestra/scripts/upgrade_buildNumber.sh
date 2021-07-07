#!/bin/bash

# Info Plist path
PATH_TO_INFOPLIST="../Orchestra"
INFOPLIST=$PATH_TO_INFOPLIST"/Info.plist"

# Type a script or drag a script file from your workspace to insert its path.
buildNumber=$(git rev-list HEAD | wc -l | tr -d ' ')

# Updrage BuildNumber with git build Numbe
oldversion=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$INFOPLIST"`

## Works 100% : Change BuildNumber
if [ "$buildNumber" != "$oldversion" ] ; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST"
fi

## Change Version 
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $1" "$INFOPLIST"