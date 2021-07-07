fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### create_app
```
fastlane create_app
```


----

## watchos
### watchos watch
```
fastlane watchos watch
```
Release testflight watch

----

## iOS
### ios signing
```
fastlane ios signing
```
Sync signing
### ios build
```
fastlane ios build
```
Build binary
### ios release_appstore
```
fastlane ios release_appstore
```
Release binary
### ios release_testflight
```
fastlane ios release_testflight
```
Build & Deploy to TestFlight
### ios testflight_pilot
```
fastlane ios testflight_pilot
```
Livraison TestFlight
### ios clean
```
fastlane ios clean
```
clean project

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
