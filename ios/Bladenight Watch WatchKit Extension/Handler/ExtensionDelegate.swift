/*
 Copyright © 2022 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


*/

import WatchKit
import UserNotifications
import Foundation
import WatchConnectivity

final class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    
    private lazy var sessionDelegator: SessionDelegator = {
        return SessionDelegator()
    }()

    // Hold the KVO observers to keep observing the change in the extension's lifetime.
    //
    private var activationStateObservation: NSKeyValueObservation?
    private var hasContentPendingObservation: NSKeyValueObservation?

    // An array to keep the background tasks.
    //
    private var wcBackgroundTasks = [WKWatchConnectivityRefreshBackgroundTask]()
    
    override init() {
        super.init()
                
        // Apps must complete WKWatchConnectivityRefreshBackgroundTask. Otherwise, tasks keep consuming
        // the background executing time and eventually cause a crash.
        // The timing to complete the tasks is when the current WCSession turns to a state other than .activated
        // or hasContentPending flips false (see completeBackgroundTasks), so use KVO to observe
        // the changes of the two properties.
        //
        activationStateObservation = WCSession.default.observe(\.activationState) { _, _ in
            DispatchQueue.main.async {
                self.completeBackgroundTasks()
            }
        }
        hasContentPendingObservation = WCSession.default.observe(\.hasContentPending) { _, _ in
            DispatchQueue.main.async {
                self.completeBackgroundTasks()
            }
        }

        // Activate the session asynchronously as early as possible.
        // When the system needs to launch the app to run a background task, this saves some background runtime budget.
        //
        WCSession.default.delegate = sessionDelegator
        WCSession.default.activate()
    }
    
    
    // Complete the background tasks, and schedule a snapshot refresh.
    //
    func completeBackgroundTasks() {
        guard !wcBackgroundTasks.isEmpty else { return }

        guard WCSession.default.activationState == .activated,
            WCSession.default.hasContentPending == false else { return }
        
        wcBackgroundTasks.forEach { $0.setTaskCompletedWithSnapshot(false) }
        
      
        // Schedule a snapshot refresh if the UI is updated by background tasks.
        //
        let date = Date(timeIntervalSinceNow: 1)
        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: date, userInfo: nil) { error in
            
            if let error = error {
                print("scheduleSnapshotRefresh error: \(error)!")
            }
        }
        wcBackgroundTasks.removeAll()
    }
    
    // Apps must complete WKWatchConnectivityRefreshBackgroundTask after the pending data is received.
    // This sample retains the tasks first, and complete them in the following cases:
    // 1. hasContentPending flips false, meaning no pending data waiting for processing. Pending data means
    //    the data the device receives prior to when the WCSession gets activated.
    //    More data might arrive, but it isn't pending when the session gets activated.
    // 2. The end of the handle method.
    //    This happens when hasContentPending flips to false before the app retains the tasks.
    //
    
  func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
    print(deviceToken.reduce("") { $0 + String(format: "%02x", $1) })
  }
    
  func applicationDidFinishLaunching() {
      Task.init {
      do {
        let success = try await UNUserNotificationCenter
          .current()
          .requestAuthorization(options: [.badge, .sound, .alert])

        guard success else { return }

        await MainActor.run {
          WKExtension.shared().registerForRemoteNotifications()
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
        func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            if let wcTask = task as? WKWatchConnectivityRefreshBackgroundTask {
                wcBackgroundTasks.append(wcTask)
                print("\(#function):\(wcTask.description) was appended!")
            } else {
                task.setTaskCompletedWithSnapshot(false)
                print("\(#function):\(task.description) was completed!")
            }
        }
        completeBackgroundTasks()
    }
    
    private func setupBackgroundRefresh() {
           let globalCalendar = Calendar.autoupdatingCurrent
           let fifteenminutesDateTime = (globalCalendar as NSCalendar).date(byAdding: .minute, value: 15, to: Date(), options: [])
           
           WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: fifteenminutesDateTime!, userInfo: nil, scheduledCompletion: { (error: Error?) in
               if let error = error {
                   print("Error occurred while scheduling background refresh: \(error.localizedDescription)")
               }
           })
           
           print("Setup background task for \(String(describing: fifteenminutesDateTime))")
       }
    
    
}

