//
//  PushNotificationProvider.swift
//  BladenightWatch WatchKit Extension
//
//  Created by Lars Huth on 21.06.22.
//

import Foundation
import PushKit

final class PushNotificationProvider: NSObject {
  let registry = PKPushRegistry(queue: .main)

  override init() {
    super.init()
    registry.delegate = self
    registry.desiredPushTypes = [.complication]
  }
}

extension PushNotificationProvider: PKPushRegistryDelegate {
  func pushRegistry(
    _ registry: PKPushRegistry,
    didUpdate pushCredentials: PKPushCredentials,
    for type: PKPushType
  ) {
    let token = pushCredentials.token.reduce("") {
      $0 + String(format: "%02x", $1)
    }
      // Send token to server.
    print(token)

    
  }
}
