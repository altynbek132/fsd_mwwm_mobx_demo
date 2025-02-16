# fsd_mwwm_mobx_demo

## Setup

- i advise to install corretto-17.0.14 in android studio and set it with
  `flutter config --jdk-dir="$HOME/Library/Java/JavaVirtualMachines/corretto-17.0.14/Contents/Home"`

- if you have adsense account set `adsenseAdClient`, `adsenseAdSlot` [here](https://github.com/altynbek132/fsd_mwwm_mobx_demo/blob/main/lib/shared/config/options.dart#L8-L9) (i could not get adsense ad client, user must verify his website)

- set `admobTestIdentifiers` in AppOptions, it will appear in the console as error on PictureResultScreen
  `I/Ads     (26896): Use RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("XXXXXXXXXXXXXXXXXXXXXXXX")) to get test ads on this device.`

run build_runner:

```bash
  dart run build_runner build --delete-conflicting-outputs
```

compile image service:

```bash
  cd _packages/image_service
  dart run build_runner build --delete-conflicting-outputs
  dart compile js "lib/image_service.web.g.dart" -o "../../web/workers/image_service.web.g.dart.js"
```

## Run

```bash
# prod
flutter run lib/main_production.dart
# dev
flutter run lib/main_development.dart
```

## Issues

- android: rate do not work, app must be published
- could not get adsense ad client, user must verify his website

## My `flutter doctor -v`

````[✓] Flutter (Channel stable, 3.27.4, on macOS 15.3 24D60 darwin-arm64, locale en-RU)
    • Flutter version 3.27.4 on channel stable at /Users/altynbekaidarbekov/fvm/versions/stable
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision d8a9f9a52e (10 days ago), 2025-01-31 16:07:18 -0500
    • Engine revision 82bd5b7209
    • Dart version 3.6.2
    • DevTools version 2.40.3

[✓] Android toolchain - develop for Android devices (Android SDK version 36.0.0-rc4)
    • Android SDK at /Users/altynbekaidarbekov/Library/Android/sdk
    • Platform android-35, build-tools 36.0.0-rc4
    • Java binary at: /Users/altynbekaidarbekov/Library/Java/JavaVirtualMachines/corretto-17.0.14/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment Corretto-17.0.14.7.1 (build 17.0.14+7-LTS)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 16.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 16C5032a
    • CocoaPods version 1.16.2

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2024.2)
    • Android Studio at /Users/altynbekaidarbekov/Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 21.0.4+-12422083-b607.1)

[✓] VS Code (version 1.97.0)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.104.0

[✓] Network resources
    • All expected network resources are available.

• No issues found!```
````
