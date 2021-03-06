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
## iOS
### ios tf
```
fastlane ios tf
```
Push a new beta build to TestFlight
### ios build_appstore
```
fastlane ios build_appstore
```
Build for App Store submission
### ios release
```
fastlane ios release
```
Push a new release build
### ios screenshots
```
fastlane ios screenshots
```
Generate new localized screenshots
### ios sandbox
```
fastlane ios sandbox
```

### ios submit_review
```
fastlane ios submit_review
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
