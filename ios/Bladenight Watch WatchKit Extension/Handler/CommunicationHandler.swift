//
//  ConnectivityRequestHandler.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 14.08.22.
//

import Foundation
import WatchConnectivity
import MapKit

class CommunicationHandler: NSObject, ObservableObject {
    private let session:WCSession
    @Published var activeEventRouteName = ""
    @Published var activeEventRouteStatusText = ""
    @Published var activeEventRouteDate = ""
    @Published var confirmationStatus = false
    @Published var isLocationTracking = false
    @Published var infoText = ""
    @Published var trackingStatus = false
    @Published var watchReachable = false
    @Published var progress = 0.1
    @Published var elapsedDistanceLength = "-"
    @Published var runningLength = "-"
    @Published var userSpeed=""
    @Published var isCompanionAppInstalled=false;
    @Published var realTimeData = RealtimeUpdate(head: nil, tail: nil, user: nil, runningLength: 0.0, routeName: "-", usr: nil);
    @Published var locations:[Location]=[Location]()
    @Published var friends:[Friend]=[Friend]()
    @Published var userlocation:Location?
    @Published var routePoints:RoutePoints?
    @Published var message:String = "Start"
    
    
    //Receive Methods from flutter flutterToWatch method aka -> sendmessage
    enum WatchReceiveMessageMethod: String {
        case setActiveEventStatusText
        case setActiveEventName
        case setActiveEventDate
        case setIsLocationTracking
        case setConfirmationStatus
        case setElapsedDistanceLength
        case setRunningLength
        case setUserSpeed
        case updateRealtimeData
        case updateUserLocationData
        case updateFriends
        case phoneAppWillTerminate
        case setRoutePoints
    }
    
    
    // Add more cases, if you have more sending methods
    enum WatchSendMethod: String {
        case sendNavToggleToFlutter
        case getEventDataFromFlutter
        case getLocationIsTracking
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

extension CommunicationHandler: WCSessionDelegate {
    
    func sessionCompanionAppInstalledDidChange(_ session: WCSession) {
        //only on ios used
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("WCSession sessionReachabilityDidChange sessionReachability:\(session.isReachable)")
        self.watchReachable=session.isReachable
        if (!session.isReachable){
            self.isLocationTracking=false;
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("WCSession activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
        debugPrint("WCSession.reachable: \(session.isReachable), WCSession.isCompanionAppInstalled: \(session.isCompanionAppInstalled)")
        watchReachable=session.isReachable;
        isCompanionAppInstalled = session.isCompanionAppInstalled;
        if (watchReachable){
            sendDataMessage(for: .getEventDataFromFlutter);
            sendDataMessage(for: .getLocationIsTracking);
        }
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            print("didReceiveMessage with replyHandler \(message)")
            self.handleIncomingMessages(message:message);
        }
    }
    
    // Receive a message From AppDelegate.swift that send from iOS devices
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        self.handleIncomingMessages(message:message);
        
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        self.handleIncomingMessages(message:applicationContext);
    }
    
    
    func sendMessage(for method: String, data: [String: Any] = [:]) {
        guard session.isReachable else {
            DispatchQueue.main.async {self.watchReachable=false}
            return
        }
        DispatchQueue.main.async { self.watchReachable=true}
        let messageData: [String: Any] = ["method": method, "data": data]
        print("sendMessage: \(messageData)")
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
    
    
    func transferUserInfo(userInfo: [String : Any]) -> WCSessionUserInfoTransfer? {
        return session.transferUserInfo(userInfo)
    }
    
    private func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: NSError?) {
        NSLog(userInfoTransfer.description + " " + (error?.localizedDescription ?? "No error"))
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        // handle receiving user info
        self.handleIncomingMessages(message:userInfo);
    }
}
