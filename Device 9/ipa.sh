#!/bin/bash

rm -r build
xcodebuild clean build
xcrun -sdk iphoneos PackageApplication -v "build/Release-iphoneos/Device 9.app" -o ~/Desktop/D9.ipa