# Changelog - BladeNight App

## [1.25.08]

### Added

- Length to tail in overlay
- scale for map

### Changed

- evenly distributed heading markers
- calc route length if not provided
- adapted to new ShareX
- open url in device browser instead inAppWebView
- images and links and friends saving with hive instead shared prefs

### Removed

- discontinued flutter_map_cancellable_tile_provider

- package upgrades

## [1.25.07]

### Added

- Bladeguardcounter
- hint for always permissions
- more arrows on map zoom in
- hint for head and tail if no always location service enabled

### Fixed

- deeplink friend import
- fix non-working onesignal action button — by removing

### Changed

- moved sponsors to direct header
- design change for home
- made goRouter case-insensitive
- updated packages

### Removed

- unnecessary routeOverview text if no event planned

## [1.25.06]

## [1.25.05]

- not released

## [1.25.04]

### Added

### Fixed

- CupertinoScrollController with nested Listview - set same ScrollController

### Changed

- decreased distances and location timeouts

### Removed#

## [1.25.03]

## [Unreleased]

### Added

- own [LogLevel] implementation

### Fixed

- realspeed raises nullpointerexception in updateWatchdate
- missing seconds in gpx-track
- Web
-
    - timeout for location refresh if the user has tracking enabled
-
    - fixed missing rotation sensor

### Changed

- Stoptimeout to 180 min
- eventupdate with to hook to in favor that only one [SimpleMapper<DateTime>] is possible - the last registered will
  used

### Removed

- Internetconnection checker—crashes on iOS

## [1.25.00] - 2025 - dev

- shakehand get server_version
- graphical improvements
- immediately event change info
- nodes in actual event transfered

## [1.24.19] - 2024-07-13

### Changed

- colored user-track-lines
- new colors for polygon layers

#### Packages

- flutter_map to V7.0.2
- onesignal to V5.2.0

### Fixed

- Update for improvement of ploygonlayer issue in fluttermap
  see https://pub.dev/packages/flutter_map/changelog

## [1.24.18] - 2024-06-23

### Fixed

- Removed nearby friend connection because many issues of Android OS with all frameworks
- Android Version from V24 to V21

### Changes

- Replaced button for Bladeguard registering by a colored Button