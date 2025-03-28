///type of locationtracking
enum TrackingType {
  ///tracking inactive
  noTracking,

  ///User is in procession and want's to support Bladenight
  userParticipating,

  ///User is in not procession and want's to show the distance
  userNotParticipating,

  ///Record only location data without sending to server
  onlyTracking,
}

enum TrackWaitStatus { none, starting, started, stopping, stopped, denied }
