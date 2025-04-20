dart run build_runner build --delete-conflicting-outputs# Bladenightapp

### The Android and iOS application for the Munich-Bladenight.

This software is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
License as published by
the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this software. If not,
see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).

You need the bladenight-server written in java to communicate routes, friends, procession ...

---

## Getting started:

* Install Intellij or Android Studio <a href="https://docs.flutter.dev/development/tools/android-studio">See external
  link</a>
* Install Dart plugin in Intellij Plugins or Android Studio
* Install Flutter plugin to Intellij or Android Studio
* Install Flutter-Intl-plugin to Intellij or Android
  Studio <a href="https://plugins.jetbrains.com/plugin/13666-flutter-intl/versions">See external link</a>
* On Mac install CocoaPods
  for Intel based Mac

  ```bash
  sudo gem install cocoapods
  ```

  for M1/M2 based Mac

  ```bash
  sudo gem uninstall ffi && sudo gem install ffi -- --enable-libffi-alloc
  ```
* Run

  ```bash
  flutter doctor -v
  ```

  in terminal to validate installation
* Get Bladenight FLutter Project from Git
* Setup firebase https://firebase.google.com/docs/crashlytics/get-started?platform=flutter&hl=de
* Setup Onesignal API Key https://documentation.onesignal.com/docs/flutter-sdk-setup
* adapt your settings to [server_connections.dart](lib%2Fapp_settings%2Fserver_connections.dart) from
  sample [server_connections_sample.dart](lib%2Fapp_settings%2Fserver_connections_sample.dart)

---

## Build:

* Create communication certificate as pkcs12 Certificate (see below) for server communication -> put it in
  assets/certs/bnp12.pkcs12</li>
* Build in IntelliJ Terminal. Enter following:
  ```bash
  flutter clean
  ```
* for Android
  ```bash
  flutter build appbundle --no-tree-shake-icons
  ```
* for iOS
    * in ios/Podfile update Onesignal version >= 5.x.x
  ```bash
   pod install --repo-update
   pod repo update
   flutter build ios
  ```
* for Web
  ```bash
  flutter build web --no-tree-shake-icons
  ```

---

## Helpful IntelliJ terminal commands:

* clean project:

  ```bash
  flutter clean
  ```
* get packages

  ```bash
  flutter packages pub get
  ```
* add package

  ```bash
  flutter packages pub add NAME_OF_PACKAGE
  ```
* show dependencies tree

  ```bash
  flutter pub deps
  ```
* Rebuild mapping/riverpod provider after changing @Mappable @riverpod annotiations class / class not found

  ```bash
  flutter clean
  flutter packages pub get
  dart run build_runner build -d
  ```
* Rebuild riverpod providers / Mapping watch on editing and save

  ```bash
  dart run build_runner watch -d
  ```  

## Build Icons Android

* icon is saved in assets folder

 ```bash
  dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
 ``` 

## Build Native splash

 ```bash
  dart run flutter_native_splash:create
 ```

## Connection

Create a valid ssl cert on serverside and
add basic auth credentials to [server_connections.dart](lib%2Fapp_settings%2Fserver_connections.dart) like 'wss://key:
pass@your.server.de:8081/ws';

## Versioning

* see https://docs.flutter.dev/deployment/android for signingConfiguration
* Increase buildnumber in pubspec.yml version: 1.0.0+1 change to version: 1.0.0+2
* flutter build ios --release-name --release-number will update version in iOS
* update version for android (android/local.properties)
  ```bash
  flutter pub get
  flutter run
  ```

---

Known issues
------------

### Can't build Android app

* missing local.properties
  add local.properties file to Project [android](android)
  with following content
  ```
  flutter.buildMode=release
  flutter.sdk=/pathToFolder/development/flutter
  sdk.dir=/pathToFolder/Android/sdk
  flutter.versionName=1.25.02
  ```

### Cant't run on iPhone. message:„iproxy“ kann nicht geöffnet werden, da der Entwickler nicht verifiziert werden kann.

cd FLUTTER SDK DIRECTORY/flutter/bin/cache/artifacts/usbmuxd
sudo xattr -d com.apple.quarantine iproxy

### flutter packages pub run build_runner build --delete-conflicting-outputs

* Stops with Unhandled exception: Bad state: Unable to generate package graph,
  no `...bladenightapp-flutter/.dart_tool/flutter_gen/pubspec.yaml` found.
  Problem appears because Mapperfiles can't created.
  Reason in pubspec.yaml is
  set to true -->set it to false
  flutter: generate: false
  then in terminal enter:
  ```bash
  flutter clean
  flutter pub get
  dart run build_runner build --delete-conflicting-outputs
  ```

### Error (Xcode): unable to resolve product type 'com.apple.product-type.application.watchapp2' for platform 'iphonesimulator'</br>

* Error (Xcode): Couldn't look up product type 'com.apple.product-type.watchkit2-extension' in domain 'iphonesimulator':
  Couldn't load spec with identifier 'com.apple.product-type.watchkit2-extension' in domain 'iphonesimulator' when run
  in DebugMode
  Add following two lines to Watchkit Extension
  [Info.plist](ios%2FRunner%2FInfo.plist)
  before last &lt;/dict&gt;

  ```
  <key>WKCompanionAppBundleIdentifier</key>
  <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
  ```

### XCode Release Build Error

* Run the following commands from the project directory terminal :
  ios/% pod deintegrate
  ios/% pod install
  Then start new build
* ```
  flutter clean
  rm -rf ios/Pods
  rm -rf ios/Podfile.lock
  rm -rf ~/Library/Developer/Xcode/DerivedData
  ```

### Rebuilding Flutter map

* during locationprovider notifylistener() executen Flutter map will rebuilding entire map_page

### Error Crash

- Problematic is actual location 4.0 - watching out for a better solution

### TODO

- fix BG - if off hide all other switches
- mapbuttons - landscape horizontal instead vertical
- overlay map
- checkin bg
- count bg onsite
- ios deeplink closed app
- 