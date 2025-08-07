//
//  activeEventViewmodel.swift
//  BladenightWatch WatchKit Extension
//
//  Created by Lars Huth on 04.06.22.
//

import Foundation
import WatchConnectivity

class ConnectivityRequestHandler: NSObject, ObservableObject {
    private let session:WCSession
    @Published var activeEventRouteName = ""
    @Published var activeEventRouteStatusText = ""
    @Published var activeEventRouteDate = ""
    @Published var confirmationStatus = false
    @Published var isLocationTracking = false
    @Published var trackingStatus = false
    @Published var watchReachable = false
    @Published var progress = 0.1
    @Published var elapsedDistanceLength = "-"
    @Published var runningLength = "-"
    
    
    
    // Add more cases if you have more receive method
    enum WatchReceiveMethod: String {
        case setActiveEventStatusText
        case setActiveEventName
        case setActiveEventDate
        case setIsLocationTracking
        case setConfirmationStatus
        case setTrackingProgress
        case setElapsedDistanceLength
        case setRunningLength
        
        
    }
    
    // Add more cases if you have more sending method
    enum WatchSendMethod: String {
        case sendNavToggleToFlutter
        case getEventDataFromFlutter
        
    }
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        
    }
    
    func sendDataMessage(for method: WatchSendMethod, data: [String: Any] = [:]) {
        if (session.activationState  == WCSessionActivationState.activated){
            debugPrint("WCSession send \(data.values)")
            sendMessage(for: method.rawValue, data: data)
            
        }
        else{
            debugPrint("WCSession not active")
        }
    }
    
}

extension ConnectivityRequestHandler: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("WCSession activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
        debugPrint("WCSession.reachable: \(session.isReachable), WCSession.isWatchAppInstalled: \(session.isCompanionAppInstalled)")
        
    }
    
    // Receive a message From AppDelegate.swift that send from iOS devices
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("didReceiveMessage: \(message)")
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
                return
            }
            self.watchReachable = session.isReachable
            switch enumMethod {
            case .setActiveEventDate:
                self.activeEventRouteDate = (message["data"] as? String) ?? "-"
            case .setActiveEventStatusText:
                self.activeEventRouteStatusText = (message["data"] as? String) ?? "-"
            case .setActiveEventName:
                self.activeEventRouteName = (message["data"] as? String) ?? "-"
            case .setConfirmationStatus:
                let nr = message["data"] as? NSNumber;
                self.confirmationStatus = nr == 1 ? true: false
            case .setIsLocationTracking:
                let nr = message["data"] as? NSNumber;
                self.isLocationTracking = nr == 1 ? true: false
                 // default: break
            case .setElapsedDistanceLength:
                self.elapsedDistanceLength = (message["data"] as? String) ?? "-"
                break
            case .setTrackingProgress:
                let nr = message["data"] as? Double;
                self.progress = nr ?? 0.0
                break
            case .setRunningLength:
                self.runningLength = (message["data"] as? String) ?? "-"
                break
            }
        }
    }
    
    
    func sendMessage(for method: String, data: [String: Any] = [:]) {
        
        guard session.isReachable else {
            DispatchQueue.main.async {self.watchReachable=false}
            return
        }
        DispatchQueue.main.async { self.watchReachable=true}
        let messageData: [String: Any] = ["method": method, "data": data]
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
}

extension ConnectivityRequestHandler: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("WCSession activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
        debugPrint("WCSession.reachable: \(session.isReachable), WCSession.isWatchAppInstalled: \(session.isCompanionAppInstalled)")
        
    }
    
    // Receive a message From AppDelegate.swift that send from iOS devices
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("didReceiveMessage: \(message)")
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMethod(rawValue: method) else {
                return
            }
            self.watchReachable = session.isReachable
            switch enumMethod {
            case .setActiveEventDate:
                self.activeEventRouteDate = (message["data"] as? String) ?? "-"
            case .setActiveEventStatusText:
                self.activeEventRouteStatusText = (message["data"] as? String) ?? "-"
            case .setActiveEventName:
                self.activeEventRouteName = (message["data"] as? String) ?? "-"
            case .setConfirmationStatus:
                let nr = message["data"] as? NSNumber;
                self.confirmationStatus = nr == 1 ? true: false
            case .setIsLocationTracking:
                let nr = message["data"] as? NSNumber;
                self.isLocationTracking = nr == 1 ? true: false
                 // default: break
            case .setElapsedDistanceLength:
                self.elapsedDistanceLength = (message["data"] as? String) ?? "-"
                break
            case .setTrackingProgress:
                let nr = message["data"] as? Double;
                self.progress = nr ?? 0.0
                break
            case .setRunningLength:
                self.runningLength = (message["data"] as? String) ?? "-"
                break
            }
        }
    }
    
    
    func sendMessage(for method: String, data: [String: Any] = [:]) {
        
        guard session.isReachable else {
            DispatchQueue.main.async {self.watchReachable=false}
            return
        }
        DispatchQueue.main.async { self.watchReachable=true}
        let messageData: [String: Any] = ["method": method, "data": data]
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
}

