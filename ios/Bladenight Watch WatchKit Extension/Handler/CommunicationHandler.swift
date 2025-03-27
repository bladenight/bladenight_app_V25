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
    @Published var activeEvent:WatchEvent = WatchEvent(
        title:"Nächste BladeNight",
        startDate: "-",
        duration: 240,
        routeName: "-",
        status: "-",
        routeLength: "0 m",
        startPointLatitude: nil,
        startPointLongitude: nil,
        startPoint: nil,
        lastUpdate: nil,
        routePoints: nil
    )
    @Published var updateEventDataLastUpdate = "-"
    @Published var activeEventRouteName = ""
    @Published var activeEventRouteStatusText = ""
    @Published var activeEventRouteDate = ""
    @Published var confirmationStatus = false
    @Published var isLocationTracking = false
    @Published var infoText = ""
    @Published var trackingStatus = false
    @Published var phoneReachable = false
    @Published var progress = 0.1
    @Published var elapsedDistanceLength = "-"
    @Published var runningLength = "-"
    @Published var userSpeed=""
    @Published var isCompanionAppInstalled=false
    @Published var realTimeData = RealtimeUpdate(head: nil, tail: nil, user: nil, runningLength: 0.0, routeName: "-", usr: nil)
    @Published var realTimeDataLastUpdate = "-"
    @Published var locations:[Location]=[Location]()
    @Published var friends:[Friend]=[Friend]()
    @Published var friendDataLastUpdate:String = "-"
    @Published var userlocation:Location?
    @Published var routePoints:RoutePoints?
    @Published var message:String = "Start"
    @Published var startpoint = CLLocationCoordinate2D(
        latitude: 48.13250913196827,
        longitude: 11.543837661522703
    )
    @Published var runningRoute:[CLLocationCoordinate2D]=[CLLocationCoordinate2D]()


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
        case updateEvent
        case updateRealtimeData
        case updateUserLocationData
        case updateFriends
        case phoneAppWillTerminate
        case setRoutePoints
        case updateRunningRoute
    }


    // Add more cases, if you have more sending methods
    enum WatchSendMethod: String {
        case sendNavToggleToFlutter
        case getEventDataFromFlutter
        case getLocationIsTracking
        case getFriendsDataFromFlutter
        case getRealtimeDataFromFlutter
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

    func transferBgDataMessage(for method: WatchSendMethod, data: [String: Any] = [:]) {
        if (session.activationState  == WCSessionActivationState.activated){
            debugPrint("WCSession send \(data.values)")
           _ = transferUserInfo(for: method.rawValue, data: data)
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
        debugPrint("WCSession sessionReachabilityDidChange sessionReachability:\(session.isReachable)")
        self.phoneReachable=session.isReachable && session.isCompanionAppInstalled
        if (!session.isReachable){
            self.isLocationTracking=false;
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("WCSession activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
        debugPrint("WCSession.reachable: \(session.isReachable), WCSession.isCompanionAppInstalled: \(session.isCompanionAppInstalled)")
        phoneReachable=session.isReachable;
        isCompanionAppInstalled = session.isCompanionAppInstalled;
        if (phoneReachable){
            sendDataMessage(for: .getEventDataFromFlutter);
            sendDataMessage(for: .getLocationIsTracking);
            sendDataMessage(for: .getFriendsDataFromFlutter);
            sendDataMessage(for: .getRealtimeDataFromFlutter)
        }
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            debugPrint("didReceiveMessage with replyHandler \(message)")
            self.handleIncomingMessages(message:message);
        }
    }

    // Receive a message From AppDelegate.swift that send from iOS devices
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
        self.handleIncomingMessages(message:message);
        }

    }

    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        DispatchQueue.main.async {
            self.handleIncomingMessages(message:applicationContext);

        }
    }


    func sendMessage(for method: String, data: [String: Any] = [:]) {
        guard session.isReachable,session.isCompanionAppInstalled else {
            DispatchQueue.main.async {self.phoneReachable=false}
            return
        }
        DispatchQueue.main.async { self.phoneReachable=true}
        let messageData: [String: Any] = ["method": method, "data": data]
        debugPrint("sendMessage: \(messageData)")
        session.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
    }
    
    
    
    func transferUserInfo(for method: String, data: [String: Any] = [:]) -> WCSessionUserInfoTransfer? {
        let messageData: [String: Any] = ["method": method, "data": data]
        print("sendMessage: \(messageData)")
        return session.transferUserInfo(messageData)
    }
    
    private func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: NSError?) {
        NSLog("CommunicationHandler didFinishUserInfoTransfer" + userInfoTransfer.description + " " + (error?.localizedDescription ?? "No error"))
    }
    
    private func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]){
        print(applicationContext)
        self.handleIncomingMessages(message:applicationContext);
    }
    
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        // handle receiving user info
        self.handleIncomingMessages(message:userInfo);
    }
    

       func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
           print("CommunicationHandler: ", "didFinish userInfoTransfer")
       }

     

       func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
           print("CommunicationHandler: ", "didFinish fileTransfer")
       }

       func session(_ session: WCSession, didReceive file: WCSessionFile) {
           print("CommunicationHandler: ", "didReceive file")
       }
}

