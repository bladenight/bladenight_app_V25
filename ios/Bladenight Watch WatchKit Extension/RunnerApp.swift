//
//  RunnerApp.swift
//  BladenightWatch WatchKit Extension
//
//  Created by Lars Huth on 04.06.22.
//

import SwiftUI

@main
struct RunnerApp: App {
    
    @WKExtensionDelegateAdaptor private var extensionDelegate: ExtensionDelegate

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "bnNotification")
    }
       
    
}
